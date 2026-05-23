<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Productos - GourmetFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .hidden { display: none !important; }
    </style>
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
                    <h2>Gestión de Menú e Inventario</h2>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/productos/nuevo" class="btn btn-primary">
                        + Registrar Producto
                    </a>
                </div>
            </div>

            <div class="page-body">
                <c:if test="${param.msg == 'guardado'}">
                    <div class="alert alert-success">
                        <span>✅ Producto guardado correctamente.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'eliminado'}">
                    <div class="alert alert-success">
                        <span>✅ Producto marcado como no disponible con éxito.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'precioActualizado'}">
                    <div class="alert alert-success">
                        <span>✅ Precio del producto actualizado e historial registrado correctamente.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'error'}">
                    <div class="alert alert-danger">
                        <span>⚠️ Hubo un error al procesar el producto.</span>
                    </div>
                </c:if>

                <div class="section-card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Imagen</th>
                                    <th>Nombre / Descripción</th>
                                    <th>Categoría</th>
                                    <th>Precio</th>
                                    <th>Stock (Cocina)</th>
                                    <th>Disponibilidad</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${productos}">
                                    <tr>
                                        <td>
                                            <img src="${not empty p.imagenUrl ? p.imagenUrl : 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=100'}" 
                                                 alt="${p.nombre}" class="thumbnail-round">
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; font-size: 1.05rem;">${p.nombre}</div>
                                            <div style="font-size: 0.8rem; color: #a0aec0; max-width: 320px;">${p.descripcion}</div>
                                        </td>
                                        <td>
                                            <span class="badge badge-info">${p.categoria.nombre}</span>
                                        </td>
                                        <td>
                                            <div style="font-weight: 700; color: hsl(var(--primary));">$${p.precio}</div>
                                            <c:if test="${p.precioAnterior != null}">
                                                <div style="font-size: 0.75rem; text-decoration: line-through; color: #a0aec0;">
                                                    Antes: $${p.precioAnterior}
                                                </div>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span style="font-weight: 700; color: ${p.stock <= p.stockMinimo ? 'hsl(var(--danger))' : 'inherit'}">
                                                ${p.stock}
                                            </span>
                                            <span style="font-size: 0.75rem; color: #a0aec0;"> (Mín: ${p.stockMinimo})</span>
                                            <c:if test="${p.stock <= p.stockMinimo}">
                                                <div class="badge badge-danger" style="font-size: 0.6rem; padding: 0.1rem 0.3rem; display: block; width: max-content; margin-top: 0.25rem;">
                                                    Bajo Stock
                                                </div>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="badge ${p.disponible ? 'badge-success' : 'badge-danger'}">
                                                ${p.disponible ? 'Disponible' : 'Agotado'}
                                            </span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 0.4rem; flex-wrap: wrap;">
                                                <a href="${pageContext.request.contextPath}/admin/productos/editar?id=${p.id}" 
                                                   class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">
                                                    Editar
                                                </a>
                                                <button onclick="abrirModalPrecio(${p.id}, '${p.nombre}', ${p.precio})" 
                                                        class="btn btn-primary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem; background-color: #4f46e5;">
                                                    Precio
                                                </button>
                                                <c:if test="${p.disponible}">
                                                    <a href="${pageContext.request.contextPath}/admin/productos/eliminar?id=${p.id}" 
                                                       class="btn btn-danger" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;"
                                                       onclick="return confirm('¿Marcar este producto como agotado?');">
                                                        Agotar
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

    <!-- Modal para Actualizar Precios e Historial -->
    <div id="modalPrecio" class="modal-backdrop hidden">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">Actualizar Precio de Producto</div>
                <button onclick="cerrarModalPrecio()" class="close-btn">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/productos/precio" method="POST">
                <input type="hidden" id="modalProductoId" name="productoId">
                
                <div class="form-group">
                    <label>Producto</label>
                    <input type="text" id="modalProductoNombre" class="form-control" readonly style="background-color: #f1f5f9;">
                </div>

                <div class="form-group">
                    <label for="modalPrecioNuevo">Nuevo Precio ($)</label>
                    <input type="number" step="0.01" id="modalPrecioNuevo" name="precio" class="form-control" required min="0.01">
                </div>

                <div class="form-group">
                    <label for="modalMotivo">Motivo del Ajuste de Precio</label>
                    <textarea id="modalMotivo" name="motivo" class="form-control" placeholder="Ej. Aumento del costo de insumos o inflación." required style="height: 100px; resize: none;"></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                    <button type="button" onclick="cerrarModalPrecio()" class="btn btn-secondary">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Actualizar Precio</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function abrirModalPrecio(id, nombre, precioActual) {
            document.getElementById('modalProductoId').value = id;
            document.getElementById('modalProductoNombre').value = nombre;
            document.getElementById('modalPrecioNuevo').value = precioActual;
            document.getElementById('modalPrecioNuevo').focus();
            document.getElementById('modalPrecio').classList.remove('hidden');
        }

        function cerrarModalPrecio() {
            document.getElementById('modalPrecio').classList.add('hidden');
        }
    </script>
</body>
</html>
