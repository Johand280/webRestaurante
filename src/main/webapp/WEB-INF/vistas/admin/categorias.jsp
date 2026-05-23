<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Categorías - GourmetFlow</title>
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
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/productos">🍕 Productos</a>
                </li>
                <li class="sidebar-menu-item active">
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
                    <h2>Categorías del Menú</h2>
                </div>
            </div>

            <div class="page-body">
                <c:if test="${param.msg == 'guardado'}">
                    <div class="alert alert-success">
                        <span>✅ Categoría procesada correctamente.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'error'}">
                    <div class="alert alert-danger">
                        <span>⚠️ Hubo un error al procesar la categoría.</span>
                    </div>
                </c:if>

                <!-- Panel Dual de Categorías -->
                <div class="dashboard-sections">
                    
                    <!-- Columna Izquierda: Listado -->
                    <div class="section-card">
                        <div class="section-title">Categorías Existentes</div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Descripción</th>
                                        <th>Estado</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${categorias}">
                                        <tr>
                                            <td>#${c.id}</td>
                                            <td><strong>${c.nombre}</strong></td>
                                            <td style="color: #718096; font-size: 0.85rem;">${c.descripcion}</td>
                                            <td>
                                                <span class="badge ${c.activo ? 'badge-success' : 'badge-danger'}">
                                                    ${c.activo ? 'Activa' : 'Inactiva'}
                                                </span>
                                            </td>
                                            <td>
                                                <button onclick="cargarParaEditar(${c.id}, '${c.nombre}', '${c.descripcion}')" 
                                                        class="btn btn-secondary" style="padding: 0.3rem 0.6rem; font-size: 0.75rem;">
                                                    Editar
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty categorias}">
                                        <tr>
                                            <td colspan="5" style="text-align: center; color: #a0aec0;">No hay categorías registradas.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Columna Derecha: Formulario de Creación / Edición -->
                    <div class="section-card">
                        <div class="section-title" id="formTitle">Nueva Categoría</div>
                        <form action="${pageContext.request.contextPath}/admin/categorias/guardar" method="POST">
                            <input type="hidden" id="catId" name="id" value="">

                            <div class="form-group">
                                <label for="nombre">Nombre de la Categoría</label>
                                <input type="text" id="catNombre" name="nombre" class="form-control" 
                                       placeholder="Ej. Hamburguesas, Ensaladas" required>
                            </div>

                            <div class="form-group">
                                <label for="descripcion">Descripción</label>
                                <textarea id="catDescripcion" name="descripcion" class="form-control" 
                                          placeholder="Describe brevemente la sección..." style="height: 100px; resize: none;"></textarea>
                            </div>

                            <div style="margin-top: 2rem; display: flex; gap: 0.8rem;">
                                <button type="button" id="btnLimpiar" onclick="resetearFormulario()" class="btn btn-secondary btn-block" style="display: none;">
                                    Cancelar Editar
                                </button>
                                <button type="submit" id="btnGuardar" class="btn btn-primary btn-block">
                                    Registrar Categoría
                                </button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        function cargarParaEditar(id, nombre, descripcion) {
            document.getElementById('catId').value = id;
            document.getElementById('catNombre').value = nombre;
            document.getElementById('catDescripcion').value = descripcion;
            
            document.getElementById('formTitle').innerText = 'Editar Categoría #' + id;
            document.getElementById('btnGuardar').innerText = 'Guardar Cambios';
            document.getElementById('btnLimpiar').style.display = 'block';
            document.getElementById('catNombre').focus();
        }

        function resetearFormulario() {
            document.getElementById('catId').value = '';
            document.getElementById('catNombre').value = '';
            document.getElementById('catDescripcion').value = '';
            
            document.getElementById('formTitle').innerText = 'Nueva Categoría';
            document.getElementById('btnGuardar').innerText = 'Registrar Categoría';
            document.getElementById('btnLimpiar').style.display = 'none';
        }
    </script>
</body>
</html>
