<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${producto == null ? "Nuevo" : "Editar"} Producto - GourmetFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                🍔 GourmetFlow
            </div>
            <div class="sidebar-user">
                <div class="avatar">${sessionScope.usuario.nombre.substring(0,1)}</div>
                <div class="user-info">
                    <div class="name">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</div>
                    <div class="role">Administrador</div>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Dashboard</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/usuarios">👥 Usuarios</a>
                </li>
                <li class="sidebar-menu-item active">
                    <a href="${pageContext.request.contextPath}/admin/productos">🍕 Productos</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/categorias">📁 Categorías</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/pedidos">📝 Pedidos</a>
                </li>
            </ul>
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-block">Cerrar Sesión</a>
            </div>
        </div>

        <!-- Contenido Principal -->
        <div class="main-content">
            <div class="main-header">
                <div class="page-title">
                    <h2>${producto == null ? "Registrar Nuevo Producto" : "Editar Datos de Producto"}</h2>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/productos" class="btn btn-secondary">
                        Volver al Menú
                    </a>
                </div>
            </div>

            <div class="page-body">
                <div class="section-card" style="max-width: 650px; margin: 0 auto;">
                    <form action="${pageContext.request.contextPath}/admin/productos/guardar" method="POST">
                        <c:if test="${producto != null}">
                            <input type="hidden" name="id" value="${producto.id}">
                        </c:if>

                        <div class="form-group">
                            <label for="nombre">Nombre del Producto o Plato</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" 
                                   placeholder="Ej. Lomo Saltado" required value="${producto.nombre}">
                        </div>

                        <div class="form-group">
                            <label for="descripcion">Descripción</label>
                            <textarea id="descripcion" name="descripcion" class="form-control" 
                                      placeholder="Describe los ingredientes, tamaño, etc." style="height: 100px; resize: none;">${producto.descripcion}</textarea>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label for="precio">Precio de Venta ($)</label>
                                <input type="number" step="0.01" id="precio" name="precio" class="form-control" 
                                       placeholder="10.50" required value="${producto.precio}">
                            </div>
                            <div class="form-group">
                                <label for="categoriaId">Categoría</label>
                                <select id="categoriaId" name="categoriaId" class="form-control" required>
                                    <option value="" disabled selected>-- Elige una categoría --</option>
                                    <c:forEach var="cat" items="${categorias}">
                                        <option value="${cat.id}" ${producto != null && producto.categoria.id == cat.id ? "selected" : ""}>
                                            ${cat.nombre}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label for="stock">Stock Actual</label>
                                <input type="number" id="stock" name="stock" class="form-control" 
                                       placeholder="20" required value="${producto.stock != null ? producto.stock : 0}">
                            </div>
                            <div class="form-group">
                                <label for="stockMinimo">Stock Mínimo (Alerta)</label>
                                <input type="number" id="stockMinimo" name="stockMinimo" class="form-control" 
                                       placeholder="5" required value="${producto.stockMinimo != null ? producto.stockMinimo : 5}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="imagenUrl">URL de la Imagen (Unsplash u otro servidor)</label>
                            <input type="url" id="imagenUrl" name="imagenUrl" class="form-control" 
                                   placeholder="https://images.unsplash.com/photo-..." value="${producto.imagenUrl}">
                        </div>

                        <div class="form-group" style="margin-top: 1rem;">
                            <label for="disponible" style="display: inline-flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                <input type="checkbox" id="disponible" name="disponible" style="width: 18px; height: 18px;" 
                                       ${producto == null || producto.disponible ? "checked" : ""}>
                                <span>Producto Disponible en Menú</span>
                            </label>
                        </div>

                        <div style="margin-top: 2.5rem; display: flex; justify-content: flex-end; gap: 1rem;">
                            <a href="${pageContext.request.contextPath}/admin/productos" class="btn btn-secondary">Cancelar</a>
                            <button type="submit" class="btn btn-primary">
                                ${producto == null ? "Registrar Producto" : "Guardar Cambios"}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
