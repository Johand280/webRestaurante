package com.restaurante.servlet;

import com.restaurante.dao.*;
import com.restaurante.modelo.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "TrabajadorServlet", urlPatterns = "/trabajador/*")
public class TrabajadorServlet extends HttpServlet {

    private final ProductoDAO  productoDAO  = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final PedidoDAO    pedidoDAO    = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!validar(req, resp)) return;
        switch (getPath(req)) {
            case "/dashboard":
                dashboard(req, resp);
                break;
            case "/productos":
                req.setAttribute("productos",  productoDAO.listarTodos());
                req.setAttribute("categorias", categoriaDAO.listarTodas());
                forward(req, resp, "/WEB-INF/vistas/trabajador/productos.jsp");
                break;
            case "/pedidos":
                req.setAttribute("pedidos", pedidoDAO.listarTodos());
                forward(req, resp, "/WEB-INF/vistas/trabajador/pedidos.jsp");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/trabajador/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!validar(req, resp)) return;
        switch (getPath(req)) {
            case "/productos/precio": {
                int id = Integer.parseInt(req.getParameter("productoId"));
                BigDecimal precio = new BigDecimal(req.getParameter("precio"));
                String motivo = req.getParameter("motivo");
                Usuario u = (Usuario) req.getSession().getAttribute("usuario");
                productoDAO.actualizarPrecio(id, precio, u.getId(), motivo);
                resp.sendRedirect(req.getContextPath() + "/trabajador/productos?msg=precioActualizado");
                break;
            }
            case "/productos/stock": {
                int id = Integer.parseInt(req.getParameter("productoId"));
                int stock = Integer.parseInt(req.getParameter("stock"));
                productoDAO.actualizarStock(id, stock);
                resp.sendRedirect(req.getContextPath() + "/trabajador/productos?msg=stockActualizado");
                break;
            }
            case "/pedidos/estado": {
                int pedidoId = Integer.parseInt(req.getParameter("pedidoId"));
                String estado = req.getParameter("estado");
                pedidoDAO.actualizarEstado(pedidoId, estado);
                resp.sendRedirect(req.getContextPath() + "/trabajador/pedidos?msg=actualizado");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/trabajador/dashboard");
                break;
        }
    }

    private void dashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("productos",    productoDAO.listarTodos());
        req.setAttribute("stockBajo",    productoDAO.listarStockBajo());
        req.setAttribute("pedidosActivos", pedidoDAO.listarTodos().stream()
                .filter(p -> !Pedido.ENTREGADO.equals(p.getEstado()) && !Pedido.CANCELADO.equals(p.getEstado()))
                .toList());
        forward(req, resp, "/WEB-INF/vistas/trabajador/dashboard.jsp");
    }

    private boolean validar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); return false;
        }
        Usuario u = (Usuario) session.getAttribute("usuario");
        if (!u.esTrabajador() && !u.esAdministrador()) {
            resp.sendRedirect(req.getContextPath() + "/acceso-denegado.jsp"); return false;
        }
        return true;
    }
    private String getPath(HttpServletRequest req) { String p = req.getPathInfo(); return p == null ? "/" : p; }
    private void forward(HttpServletRequest req, HttpServletResponse resp, String jsp) throws ServletException, IOException {
        req.getRequestDispatcher(jsp).forward(req, resp);
    }
}