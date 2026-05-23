package com.restaurante.servlet;

import com.restaurante.dao.*;
import com.restaurante.modelo.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = "/admin/*")
public class AdminServlet extends HttpServlet {

    private final UsuarioDAO   usuarioDAO   = new UsuarioDAO();
    private final ProductoDAO  productoDAO  = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();
    private final PedidoDAO    pedidoDAO    = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!validarAdmin(req, resp)) return;

        String path = getPath(req);

        switch (path) {
            case "/dashboard":
                dashboard(req, resp);
                break;
            case "/usuarios":
                listarUsuarios(req, resp);
                break;
            case "/usuarios/nuevo":
                formUsuario(req, resp, null);
                break;
            case "/usuarios/editar":
                editarUsuario(req, resp);
                break;
            case "/usuarios/eliminar":
                eliminarUsuario(req, resp);
                break;
            case "/productos":
                listarProductos(req, resp);
                break;
            case "/productos/nuevo":
                formProducto(req, resp, null);
                break;
            case "/productos/editar":
                editarProducto(req, resp);
                break;
            case "/productos/eliminar":
                eliminarProducto(req, resp);
                break;
            case "/categorias":
                listarCategorias(req, resp);
                break;
            case "/pedidos":
                listarPedidos(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!validarAdmin(req, resp)) return;
        String path = getPath(req);

        switch (path) {
            case "/usuarios/guardar":
                guardarUsuario(req, resp);
                break;
            case "/productos/guardar":
                guardarProducto(req, resp);
                break;
            case "/productos/precio":
                actualizarPrecio(req, resp);
                break;
            case "/categorias/guardar":
                guardarCategoria(req, resp);
                break;
            case "/pedidos/estado":
                actualizarEstadoPedido(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    // ─── Vistas ──────────────────────────────────────────────────────────────

    private void dashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("totalProductos",   productoDAO.listarTodos().size());
        req.setAttribute("totalUsuarios",    usuarioDAO.listarTodos().size());
        req.setAttribute("totalPedidos",     pedidoDAO.listarTodos().size());
        req.setAttribute("stockBajo",        productoDAO.listarStockBajo());
        req.setAttribute("pedidosRecientes", pedidoDAO.listarTodos().stream().limit(5).toList());
        forward(req, resp, "/WEB-INF/vistas/admin/dashboard.jsp");
    }

    private void listarUsuarios(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("usuarios", usuarioDAO.listarTodos());
        forward(req, resp, "/WEB-INF/vistas/admin/usuarios.jsp");
    }

    private void formUsuario(HttpServletRequest req, HttpServletResponse resp, Usuario usuario)
            throws ServletException, IOException {
        req.setAttribute("usuario", usuario);
        req.setAttribute("roles",   usuarioDAO.listarRoles());
        forward(req, resp, "/WEB-INF/vistas/admin/usuarioForm.jsp");
    }

    private void editarUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        formUsuario(req, resp, usuarioDAO.buscarPorId(id));
    }

    private void eliminarUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        usuarioDAO.eliminar(id);
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios?msg=eliminado");
    }

    private void listarProductos(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("productos",   productoDAO.listarTodos());
        req.setAttribute("categorias",  categoriaDAO.listarTodas());
        forward(req, resp, "/WEB-INF/vistas/admin/productos.jsp");
    }

    private void formProducto(HttpServletRequest req, HttpServletResponse resp, Producto producto)
            throws ServletException, IOException {
        req.setAttribute("producto",    producto);
        req.setAttribute("categorias",  categoriaDAO.listarTodas());
        forward(req, resp, "/WEB-INF/vistas/admin/productoForm.jsp");
    }

    private void editarProducto(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        formProducto(req, resp, productoDAO.buscarPorId(id));
    }

    private void eliminarProducto(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        productoDAO.eliminar(id);
        resp.sendRedirect(req.getContextPath() + "/admin/productos?msg=eliminado");
    }

    private void listarCategorias(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("categorias", categoriaDAO.listarTodas());
        forward(req, resp, "/WEB-INF/vistas/admin/categorias.jsp");
    }

    private void listarPedidos(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pedidos", pedidoDAO.listarTodos());
        forward(req, resp, "/WEB-INF/vistas/admin/pedidos.jsp");
    }

    // ─── Acciones ────────────────────────────────────────────────────────────

    private void guardarUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idParam = req.getParameter("id");
        Usuario u = new Usuario();
        if (idParam != null && !idParam.isBlank()) u.setId(Integer.parseInt(idParam));
        u.setNombre(req.getParameter("nombre"));
        u.setApellido(req.getParameter("apellido"));
        u.setEmail(req.getParameter("email"));
        u.setPassword(req.getParameter("password"));
        u.setTelefono(req.getParameter("telefono"));
        u.setActivo("on".equals(req.getParameter("activo")));
        Rol rol = new Rol(); rol.setId(Integer.parseInt(req.getParameter("rolId")));
        u.setRol(rol);

        boolean ok = (u.getId() == 0) ? usuarioDAO.insertar(u) : usuarioDAO.actualizar(u);
        String msg = ok ? "?msg=guardado" : "?msg=error";
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios" + msg);
    }

    private void guardarProducto(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idParam = req.getParameter("id");
        Producto p = new Producto();
        if (idParam != null && !idParam.isBlank()) p.setId(Integer.parseInt(idParam));
        p.setNombre(req.getParameter("nombre"));
        p.setDescripcion(req.getParameter("descripcion"));
        p.setPrecio(new BigDecimal(req.getParameter("precio")));
        p.setStock(Integer.parseInt(req.getParameter("stock")));
        p.setStockMinimo(Integer.parseInt(req.getParameter("stockMinimo")));
        p.setDisponible("on".equals(req.getParameter("disponible")));
        p.setImagenUrl(req.getParameter("imagenUrl"));
        Categoria cat = new Categoria(); cat.setId(Integer.parseInt(req.getParameter("categoriaId")));
        p.setCategoria(cat);

        boolean ok = (p.getId() == 0) ? productoDAO.insertar(p) : productoDAO.actualizar(p);
        String msg = ok ? "?msg=guardado" : "?msg=error";
        resp.sendRedirect(req.getContextPath() + "/admin/productos" + msg);
    }

    private void actualizarPrecio(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int productoId   = Integer.parseInt(req.getParameter("productoId"));
        BigDecimal precio = new BigDecimal(req.getParameter("precio"));
        String motivo    = req.getParameter("motivo");
        Usuario admin    = (Usuario) req.getSession().getAttribute("usuario");

        boolean ok = productoDAO.actualizarPrecio(productoId, precio, admin.getId(), motivo);
        resp.sendRedirect(req.getContextPath() + "/admin/productos?msg=" + (ok ? "precioActualizado" : "error"));
    }

    private void guardarCategoria(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idParam = req.getParameter("id");
        Categoria c = new Categoria();
        if (idParam != null && !idParam.isBlank()) c.setId(Integer.parseInt(idParam));
        c.setNombre(req.getParameter("nombre"));
        c.setDescripcion(req.getParameter("descripcion"));

        boolean ok = (c.getId() == 0) ? categoriaDAO.insertar(c) : categoriaDAO.actualizar(c);
        resp.sendRedirect(req.getContextPath() + "/admin/categorias?msg=" + (ok ? "guardado" : "error"));
    }

    private void actualizarEstadoPedido(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int pedidoId  = Integer.parseInt(req.getParameter("pedidoId"));
        String estado = req.getParameter("estado");
        pedidoDAO.actualizarEstado(pedidoId, estado);
        resp.sendRedirect(req.getContextPath() + "/admin/pedidos?msg=actualizado");
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private boolean validarAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        Usuario u = (Usuario) session.getAttribute("usuario");
        if (!u.esAdministrador()) {
            resp.sendRedirect(req.getContextPath() + "/acceso-denegado.jsp");
            return false;
        }
        return true;
    }

    private String getPath(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        return pathInfo == null ? "/" : pathInfo;
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String jsp)
            throws ServletException, IOException {
        req.getRequestDispatcher(jsp).forward(req, resp);
    }
}