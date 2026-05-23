<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Carrito de Compras - GourmetFlow</title>
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
                    <div class="role">Cliente</div>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item active">
                    <a href="${pageContext.request.contextPath}/cliente/menu">🍕 Menú Digital</a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/cliente/pedidos">📝 Mis Pedidos</a>
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
                    <h2>Resumen de Tu Pedido</h2>
                </div>
                <a href="${pageContext.request.contextPath}/cliente/menu" class="btn btn-secondary">
                    🔙 Seguir Ordenando
                </a>
            </div>

            <div class="page-body">
                <c:if test="${param.msg == 'vacio'}">
                    <div class="alert alert-danger">
                        <span>⚠️ Tu carrito está vacío. Agrega platos antes de procesar el pedido.</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'error'}">
                    <div class="alert alert-danger">
                        <span>⚠️ Hubo un error al registrar tu pedido (por ejemplo, stock insuficiente en cocina). Por favor inténtalo de nuevo.</span>
                    </div>
                </c:if>

                <div class="dashboard-sections" id="cartSection" style="grid-template-columns: 2fr 1fr;">
                    
                    <!-- Lado Izquierdo: Listado de Ítems del Carrito -->
                    <div class="section-card">
                        <div class="section-title">Platillos en tu Orden</div>
                        
                        <div class="table-responsive">
                            <table class="table" id="cartTable">
                                <thead>
                                    <tr>
                                        <th>Imagen</th>
                                        <th>Plato</th>
                                        <th>Precio Unitario</th>
                                        <th>Cantidad</th>
                                        <th>Subtotal</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody id="cartTableBody">
                                    <!-- Generado dinámicamente mediante JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Lado Derecho: Formulario de Checkout -->
                    <div class="section-card">
                        <div class="section-title">Resumen de Cuenta</div>
                        
                        <form id="checkoutForm" action="${pageContext.request.contextPath}/cliente/pedidos/crear" method="POST">
                            <!-- Los inputs ocultos del productoId y cantidad se inyectarán aquí por JS al enviar -->
                            <div id="hiddenInputsContainer"></div>

                            <div class="form-group">
                                <label for="observaciones">Instrucciones Especiales</label>
                                <textarea id="observaciones" name="observaciones" class="form-control" 
                                          placeholder="Ej. Sin cebolla, término medio, etc." style="height: 100px; resize: none;"></textarea>
                            </div>

                            <div class="cart-total-box">
                                <div class="cart-total-row">
                                    <span>Subtotal</span>
                                    <span id="txtSubtotal">$0.00</span>
                                </div>
                                <div class="cart-total-row">
                                    <span>Servicio / Impuesto (Incluido)</span>
                                    <span>$0.00</span>
                                </div>
                                <div class="cart-total-row final">
                                    <span>Total a Pagar</span>
                                    <span id="txtTotal">$0.00</span>
                                </div>
                            </div>

                            <div style="margin-top: 2rem;">
                                <button type="submit" id="btnProcesar" class="btn btn-primary btn-block">
                                    ⚡ Enviar Pedido a Cocina
                                </button>
                            </div>
                        </form>
                    </div>

                </div>

                <!-- Carrito Vacío Placeholder -->
                <div id="emptyCartPlaceholder" class="hidden" style="background-color: white; border-radius: var(--radius-lg); padding: 5rem; text-align: center; box-shadow: var(--shadow-md);">
                    <span style="font-size: 5rem;">🛒</span>
                    <h3 style="margin-top: 1.5rem; font-weight: 700;">Tu carrito está vacío</h3>
                    <p style="color: #a0aec0; margin-top: 0.5rem; margin-bottom: 2rem;">¡Explora nuestra deliciosa carta para agregar tus platillos favoritos!</p>
                    <a href="${pageContext.request.contextPath}/cliente/menu" class="btn btn-primary">
                        Ver Carta Digital
                    </a>
                </div>

            </div>
        </div>
    </div>

    <script>
        function obtenerCarrito() {
            const cartStr = localStorage.getItem('gourmetflow_cart');
            return cartStr ? JSON.parse(cartStr) : [];
        }

        function guardarCarrito(carrito) {
            localStorage.setItem('gourmetflow_cart', JSON.stringify(carrito));
            renderizarCarrito();
        }

        function renderizarCarrito() {
            const carrito = obtenerCarrito();
            
            if (carrito.length === 0) {
                document.getElementById('cartSection').classList.add('hidden');
                document.getElementById('emptyCartPlaceholder').classList.remove('hidden');
                return;
            }

            document.getElementById('cartSection').classList.remove('hidden');
            document.getElementById('emptyCartPlaceholder').classList.add('hidden');

            const tbody = document.getElementById('cartTableBody');
            tbody.innerHTML = '';
            
            let total = 0;

            carrito.forEach((item, index) => {
                const subtotal = item.precio * item.cantidad;
                total += subtotal;

                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>
                        <img src="${item.imagen ? item.imagen : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'}" class="thumbnail-round">
                    </td>
                    <td>
                        <strong style="font-size: 1rem;">${item.nombre}</strong>
                    </td>
                    <td style="font-weight: 600;">$${item.precio.toFixed(2)}</td>
                    <td>
                        <div class="quantity-control">
                            <button type="button" class="quantity-btn" onclick="actualizarCantidad(${item.id}, -1)">-</button>
                            <input type="text" class="quantity-input" value="${item.cantidad}" readonly>
                            <button type="button" class="quantity-btn" onclick="actualizarCantidad(${item.id}, 1)">+</button>
                        </div>
                    </td>
                    <td style="font-weight: 700; color: hsl(var(--primary));">$${subtotal.toFixed(2)}</td>
                    <td>
                        <button type="button" class="btn btn-danger" style="padding: 0.3rem 0.6rem; font-size: 0.75rem;" onclick="eliminarItem(${item.id})">
                            Eliminar
                        </button>
                    </td>
                `;
                tbody.appendChild(tr);
            });

            document.getElementById('txtSubtotal').innerText = '$' + total.toFixed(2);
            document.getElementById('txtTotal').innerText = '$' + total.toFixed(2);
        }

        function actualizarCantidad(id, delta) {
            let carrito = obtenerCarrito();
            let item = carrito.find(x => x.id === id);
            if (item) {
                item.cantidad += delta;
                if (item.cantidad <= 0) {
                    carrito = carrito.filter(x => x.id !== id);
                }
            }
            guardarCarrito(carrito);
        }

        function eliminarItem(id) {
            let carrito = obtenerCarrito();
            carrito = carrito.filter(x => x.id !== id);
            guardarCarrito(carrito);
        }

        // Intercepta el envío para inyectar dinámicamente los inputs ocultos estructurados
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const carrito = obtenerCarrito();
            
            if (carrito.length === 0) {
                e.preventDefault();
                alert('El carrito está vacío.');
                return;
            }

            const container = document.getElementById('hiddenInputsContainer');
            container.innerHTML = ''; // Limpiar anteriores

            carrito.forEach(item => {
                // Producto ID
                const inputId = document.createElement('input');
                inputId.type = 'hidden';
                inputId.name = 'productoId';
                inputId.value = item.id;
                container.appendChild(inputId);

                // Cantidad
                const inputCant = document.createElement('input');
                inputCant.type = 'hidden';
                inputCant.name = 'cantidad';
                inputCant.value = item.cantidad;
                container.appendChild(inputCant);
            });

            // Limpiamos el carrito local al enviar con éxito
            // Nota: dado que el envío hace redirección de página completa,
            // podemos limpiar el localStorage antes del envío.
            localStorage.removeItem('gourmetflow_cart');
        });

        document.addEventListener('DOMContentLoaded', renderizarCarrito);
    </script>
</body>
</html>
