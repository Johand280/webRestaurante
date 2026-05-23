package com.restaurante.servlet;

import com.restaurante.dao.UsuarioDAO;
import com.restaurante.modelo.Usuario;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/logout"})
public class AuthServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.contains("/logout")) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Si ya tiene sesión, redirigir según rol
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            redirigirSegunRol((Usuario) session.getAttribute("usuario"), req, resp);
            return;
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Por favor ingrese email y contraseña.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        Usuario usuario = usuarioDAO.autenticar(email.trim(), password);

        if (usuario == null) {
            req.setAttribute("error", "Credenciales incorrectas o usuario inactivo.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("usuario", usuario);
        session.setMaxInactiveInterval(60 * 60); // 1 hora

        redirigirSegunRol(usuario, req, resp);
    }

    private void redirigirSegunRol(Usuario u, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String ctx = req.getContextPath();
        if (u.esAdministrador()) {
            resp.sendRedirect(ctx + "/admin/dashboard");
        } else if (u.esTrabajador()) {
            resp.sendRedirect(ctx + "/trabajador/dashboard");
        } else {
            resp.sendRedirect(ctx + "/cliente/menu");
        }
    }
}