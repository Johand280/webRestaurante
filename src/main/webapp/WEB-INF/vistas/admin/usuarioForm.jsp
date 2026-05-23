<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${usuario == null ? "Nuevo" : "Editar"} Usuario - GourmetFlow</title>
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
                <li class="sidebar-menu-item active">
                    <a href="${pageContext.request.contextPath}/admin/usuarios">👥 Usuarios</a>
                </li>
                <li class="sidebar-menu-item">
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
                    <h2>${usuario == null ? "Registrar Nuevo Usuario" : "Editar Detalles de Usuario"}</h2>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-secondary">
                        Volver al Listado
                    </a>
                </div>
            </div>

            <div class="page-body">
                <div class="section-card" style="max-width: 600px; margin: 0 auto;">
                    <form action="${pageContext.request.contextPath}/admin/usuarios/guardar" method="POST">
                        <!-- ID oculto si estamos editando -->
                        <c:if test="${usuario != null}">
                            <input type="hidden" name="id" value="${usuario.id}">
                        </c:if>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label for="nombre">Nombre</label>
                                <input type="text" id="nombre" name="nombre" class="form-control" 
                                       placeholder="Ej. Carlos" required value="${usuario.nombre}">
                            </div>
                            <div class="form-group">
                                <label for="apellido">Apellido</label>
                                <input type="text" id="apellido" name="apellido" class="form-control" 
                                       placeholder="Ej. Gómez" required value="${usuario.apellido}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Correo Electrónico</label>
                            <input type="email" id="email" name="email" class="form-control" 
                                   placeholder="correo@restaurante.com" required value="${usuario.email}">
                        </div>

                        <div class="form-group">
                            <label for="password">Contraseña</label>
                            <input type="password" id="password" name="password" class="form-control" 
                                   placeholder="${usuario == null ? 'Establece una contraseña' : 'Ingresa una nueva o deja vacío'}" 
                                   ${usuario == null ? "required" : ""}>
                            <c:if test="${usuario != null}">
                                <small style="color: #a0aec0;">* Deja este campo en blanco para no modificar la contraseña actual.</small>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="telefono">Número de Teléfono</label>
                            <input type="text" id="telefono" name="telefono" class="form-control" 
                                   placeholder="3001234567" value="${usuario.telefono}">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label for="rolId">Rol Asignado</label>
                                <select id="rolId" name="rolId" class="form-control" required>
                                    <option value="" disabled selected>-- Selecciona un rol --</option>
                                    <c:forEach var="rol" items="${roles}">
                                        <option value="${rol.id}" ${usuario != null && usuario.rol.id == rol.id ? "selected" : ""}>
                                            ${rol.nombre}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <c:if test="${usuario != null}">
                                <div class="form-group" style="justify-content: center; align-items: start; display: flex; flex-direction: column;">
                                    <label for="activo" style="display: inline-flex; align-items: center; gap: 0.5rem; cursor: pointer; margin-top: 1.5rem;">
                                        <input type="checkbox" id="activo" name="activo" style="width: 18px; height: 18px;" 
                                               ${usuario.activo ? "checked" : ""}>
                                        <span>Usuario Activo</span>
                                    </label>
                                </div>
                            </c:if>
                        </div>

                        <div style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem;">
                            <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-secondary">Cancelar</a>
                            <button type="submit" class="btn btn-primary">
                                ${usuario == null ? "Registrar" : "Guardar Cambios"}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
