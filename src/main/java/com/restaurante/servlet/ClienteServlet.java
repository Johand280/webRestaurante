package com.restaurante.servlet;

import com.restaurante.dao.*;
import com.restaurante.modelo.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet(name = "ClienteServlet", urlPatterns = "/cliente/*")
public class ClienteServlet extends HttpServlet {

    private final ProductoDAO  productoDAO  = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final PedidoDAO    pedidoDAO    = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!validar(req, resp)) return;
        switch (getPath(req)) {
            case "/menu":
                req.setAttribute("productos",  productoDAO.listarDisponibles());
                req.setAttribute("categorias", categoriaDAO.listarTodas());
                forward(req, resp, "/WEB-INF/vistas/cliente/menu.jsp");
                break;
            case "/pedidos":
                Usuario u = (Usuario) req.getSession().getAttribute("usuario");
                req.setAttribute("pedidos", pedidoDAO.listarPorCliente(u.getId()));
                forward(req, resp, "/WEB-INF/vistas/cliente/pedidos.jsp");
                break;
            case "/carrito":
                forward(req, resp, "/WEB-INF/vistas/cliente/carrito.jsp");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/cliente/menu");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!validar(req, resp)) return;
        if ("/pedidos/crear".equals(getPath(req))) {
            crearPedido(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/cliente/menu");
        }
    }

    private void crearPedido(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Usuario cliente = (Usuario) req.getSession().getAttribute("usuario");
        String[] productosIds   = req.getParameterValues("productoId");
        String[] cantidades     = req.getParameterValues("cantidad");
        String observaciones    = req.getParameter("observaciones");

        if (productosIds == null || productosIds.length == 0) {
            resp.sendRedirect(req.getContextPath() + "/cliente/carrito?msg=vacio");
            return;
        }

        Pedido pedido = new Pedido();
        pedido.setCliente(cliente);
        pedido.setObservaciones(observaciones);

        for (int i = 0; i < productosIds.length; i++) {
            int productoId = Integer.parseInt(productosIds[i]);
            int cantidad   = Integer.parseInt(cantidades[i]);
            if (cantidad <= 0) continue;

            Producto producto = productoDAO.buscarPorId(productoId);
            if (producto != null) {
                pedido.getDetalles().add(new DetallePedido(producto, cantidad));
            }
        }

        pedido.calcularTotal();
        boolean ok = pedidoDAO.crearPedido(pedido);

        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/cliente/pedidos?msg=creado&id=" + pedido.getId());
        } else {
            resp.sendRedirect(req.getContextPath() + "/cliente/carrito?msg=error");
        }
    }

    private boolean validar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); return false;
        }
        return true;
    }
    private String getPath(HttpServletRequest req) { String p = req.getPathInfo(); return p == null ? "/" : p; }
    private void forward(HttpServletRequest req, HttpServletResponse resp, String jsp) throws ServletException, IOException {
        req.getRequestDispatcher(jsp).forward(req, resp);
    }
}