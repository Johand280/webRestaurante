<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - GourmetFlow</title>
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
                    <h2>Gestión de Usuarios</h2>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/usuarios/nuevo" class="btn btn-primary">
                        + Registrar Usuario
                    </a>
                </div>
            </div>

            <div class="page-body">
                <c:if test="${param.msg == 'guardado'}">
                    <div class="alert alert-success">
                        <span>✅ Usuario guardado con éxito.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'eliminado'}">
                    <div class="alert alert-success">
                        <span>✅ El usuario ha sido inhabilitado correctamente.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'error'}">
                    <div class="alert alert-danger">
                        <span>⚠️ Ocurrió un error al procesar el usuario.</span>
                    </div>
                </c:if>

                <div class="section-card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Usuario</th>
                                    <th>Correo</th>
                                    <th>Teléfono</th>
                                    <th>Rol</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${usuarios}">
                                    <tr>
                                        <td>#${u.id}</td>
                                        <td>
                                            <div style="font-weight: 600;">${u.nombre} ${u.apellido}</div>
                                            <div style="font-size: 0.75rem; color: #a0aec0;">Registro: ${u.fechaRegistro.toString().replace('T', ' ')}</div>
                                        </td>
                                        <td>${u.email}</td>
                                        <td>${u.telefono != null ? u.telefono : '-'}</td>
                                        <td>
                                            <span class="badge ${u.rol.id == 1 ? 'badge-primary' : (u.rol.id == 2 ? 'badge-info' : 'badge-secondary')}" 
                                                  style="${u.rol.id == 1 ? 'background-color: #e0f2fe; color: #0369a1;' : ''}">
                                                ${u.rol.nombre}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${u.activo ? 'badge-success' : 'badge-danger'}">
                                                ${u.activo ? 'Activo' : 'Inactivo'}
                                            </span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 0.5rem;">
                                                <a href="${pageContext.request.contextPath}/admin/usuarios/editar?id=${u.id}" 
                                                   class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">
                                                    Editar
                                                </a>
                                                <c:if test="${u.activo}">
                                                    <a href="${pageContext.request.contextPath}/admin/usuarios/eliminar?id=${u.id}" 
                                                       class="btn btn-danger" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;"
                                                       onclick="return confirm('¿Estás seguro de inhabilitar a este usuario?');">
                                                        Suspender
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
