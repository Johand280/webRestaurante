<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario Operativo - GourmetFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .hidden { display: none !important; }
        .inline-form { display: flex; gap: 0.25rem; align-items: center; }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                🍳 CocinaFlow
            </div>
            <div class="sidebar-user">
                <div class="avatar">${sessionScope.usuario.nombre.substring(0,1)}</div>
                <div class="user-info">
                    <div class="name">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</div>
                    <div class="role">Personal Operativo</div>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/trabajador/dashboard">📋 Resumen Actividad</a>
                </li>
                <li class="sidebar-menu-item active">
                    <a href="${pageContext.request.contextPath}/trabajador/productos">🍕 Inventario Menú</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/trabajador/pedidos">🍳 Comandas Activas</a>
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
                    <h2>Inventario de Platos e Insumos</h2>
                </div>
            </div>

            <div class="page-body">
                <c:if test="${param.msg == 'stockActualizado'}">
                    <div class="alert alert-success">
                        <span>✅ Los niveles de stock de cocina se han actualizado correctamente.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'precioActualizado'}">
                    <div class="alert alert-success">
                        <span>✅ Precio comercial actualizado y registrado en bitácora histórica.</span>
                    </div>
                </c:if>

                <div class="section-card">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Imagen</th>
                                    <th>Platillo</th>
                                    <th>Categoría</th>
                                    <th>Precio Venta</th>
                                    <th>Stock Actual</th>
                                    <th>Acciones Rápidas</th>
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
                                        </td>
                                        <td>
                                            <span style="font-weight: 700; color: ${p.stock <= p.stockMinimo ? 'hsl(var(--danger))' : 'inherit'}">
                                                ${p.stock}
                                            </span>
                                            <span style="font-size: 0.75rem; color: #a0aec0;"> (Mín: ${p.stockMinimo})</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 0.5rem; flex-direction: column;">
                                                <!-- Formulario para stock en línea -->
                                                <form action="${pageContext.request.contextPath}/trabajador/productos/stock" method="POST" class="inline-form">
                                                    <input type="hidden" name="productoId" value="${p.id}">
                                                    <input type="number" name="stock" value="${p.stock}" min="0" class="form-control" 
                                                           style="width: 70px; padding: 0.25rem 0.5rem; font-size: 0.85rem; height: auto;">
                                                    <button type="submit" class="btn btn-secondary" style="padding: 0.25rem 0.6rem; font-size: 0.75rem;">
                                                        Stock
                                                    </button>
                                                </form>
                                                <button onclick="abrirModalPrecio(${p.id}, '${p.nombre}', ${p.precio})" 
                                                        class="btn btn-primary" style="padding: 0.3rem 0.8rem; font-size: 0.8rem; width: max-content;">
                                                    Modificar Precio
                                                </button>
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
                <div class="modal-title">Modificación Comercial de Tarifas</div>
                <button onclick="cerrarModalPrecio()" class="close-btn">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/trabajador/productos/precio" method="POST">
                <input type="hidden" id="modalProductoId" name="productoId">
                
                <div class="form-group">
                    <label>Producto</label>
                    <input type="text" id="modalProductoNombre" class="form-control" readonly style="background-color: #f1f5f9;">
                </div>

                <div class="form-group">
                    <label for="modalPrecioNuevo">Precio de Venta ($)</label>
                    <input type="number" step="0.01" id="modalPrecioNuevo" name="precio" class="form-control" required min="0.01">
                </div>

                <div class="form-group">
                    <label for="modalMotivo">Justificación técnica del cambio</label>
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
