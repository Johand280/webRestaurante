<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comandas Activas de Cocina - GourmetFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .grid-comandas {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }
        .comanda-card {
            background-color: white;
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow-md);
            border: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .comanda-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px dashed #edf2f7;
            padding-bottom: 0.8rem;
            margin-bottom: 1rem;
        }
        .comanda-id {
            font-size: 1.25rem;
            font-weight: 800;
        }
        .comanda-time {
            font-size: 0.8rem;
            color: #a0aec0;
        }
        .comanda-client {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #4a5568;
        }
        .comanda-notes {
            background-color: #fffaf0;
            border-left: 4px solid hsl(var(--primary));
            padding: 0.5rem 0.8rem;
            font-size: 0.85rem;
            color: #7b341e;
            border-radius: var(--radius-sm);
            margin-top: 1rem;
        }
        .comanda-actions {
            margin-top: 1.5rem;
            display: flex;
            gap: 0.5rem;
        }
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
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/trabajador/productos">🍕 Inventario Menú</a>
                </li>
                <li class="sidebar-menu-item active">
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
                    <h2>Tablero de Comandas y Despacho</h2>
                </div>
            </div>

            <div class="page-body">
                <c:if test="${param.msg == 'actualizado'}">
                    <div class="alert alert-success">
                        <span>✅ El estado de la comanda ha sido actualizado.</span>
                    </div>
                </c:if>

                <!-- Comandas en Grid Cards para que parezca una pantalla de cocina profesional -->
                <div class="section-title">Comandas en Cocina</div>
                <div class="grid-comandas">
                    <c:forEach var="p" items="${pedidos}">
                        <!-- Mostrar solo los no completados aquí para optimizar la labor del cocina -->
                        <c:if test="${p.estado != 'ENTREGADO' && p.estado != 'CANCELADO'}">
                            <div class="comanda-card" style="border-top: 5px solid ${p.estado == 'PENDIENTE' ? 'hsl(var(--warning))' : 'hsl(var(--info))'}">
                                <div>
                                    <div class="comanda-header">
                                        <span class="comanda-id">Orden #${p.id}</span>
                                        <span class="comanda-time">${p.fechaPedido.toString().replace('T', ' ').substring(11, 16)}</span>
                                    </div>
                                    <div class="comanda-client">👤 ${p.cliente.nombre} ${p.cliente.apellido}</div>
                                    
                                    <!-- Dado que PedidoDAO.listarTodos() no carga los detalles del plato en la consulta general por performance (se carga bajo demanda), mostramos el total y notas -->
                                    <div style="font-weight: 700; font-size: 1.1rem; margin-top: 0.5rem; color: hsl(var(--primary));">
                                        Total: $${p.total}
                                    </div>

                                    <c:if test="${not empty p.observaciones}">
                                        <div class="comanda-notes">
                                            <strong>Nota especial:</strong> "${p.observaciones}"
                                        </div>
                                    </c:if>
                                </div>

                                <div class="comanda-actions">
                                    <c:if test="${p.estado == 'PENDIENTE'}">
                                        <form action="${pageContext.request.contextPath}/trabajador/pedidos/estado" method="POST" style="flex: 1; margin: 0;">
                                            <input type="hidden" name="pedidoId" value="${p.id}">
                                            <input type="hidden" name="estado" value="EN_PROCESO">
                                            <button type="submit" class="btn btn-primary btn-block" style="background-color: hsl(var(--info));">
                                                👨‍🍳 Preparar
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${p.estado == 'EN_PROCESO'}">
                                        <form action="${pageContext.request.contextPath}/trabajador/pedidos/estado" method="POST" style="flex: 1; margin: 0;">
                                            <input type="hidden" name="pedidoId" value="${p.id}">
                                            <input type="hidden" name="estado" value="ENTREGADO">
                                            <button type="submit" class="btn btn-primary btn-block" style="background-color: hsl(var(--success));">
                                                🚀 Despachar / Servir
                                            </button>
                                        </form>
                                    </c:if>
                                    <form action="${pageContext.request.contextPath}/trabajador/pedidos/estado" method="POST" style="margin: 0;">
                                        <input type="hidden" name="pedidoId" value="${p.id}">
                                        <input type="hidden" name="estado" value="CANCELADO">
                                        <button type="submit" class="btn btn-danger" style="padding: 0.8rem 1rem;" onclick="return confirm('¿Estás seguro de cancelar esta orden?');">
                                            ❌
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
                
                <c:if test="${empty pedidos}">
                    <div style="background-color: white; border-radius: var(--radius-lg); padding: 4rem; text-align: center; box-shadow: var(--shadow-md); margin-top: 1.5rem;">
                        <span style="font-size: 4rem;">🥗</span>
                        <h3 style="margin-top: 1rem; font-weight: 700;">¡Limpieza total de comandas!</h3>
                        <p style="color: #a0aec0; margin-top: 0.25rem;">No hay ningún pedido activo para preparar en cocina.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
