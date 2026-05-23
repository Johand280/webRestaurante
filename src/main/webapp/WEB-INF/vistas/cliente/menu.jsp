<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menú Digital - GourmetFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .menu-filter-section {
            margin-bottom: 2.5rem;
        }
        .menu-search-input {
            width: 100%;
            max-width: 400px;
            margin-bottom: 1.5rem;
        }
        .add-cart-btn {
            background-color: hsl(var(--primary));
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }
        .add-cart-btn:hover {
            background-color: hsl(var(--primary-hover));
        }
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
                    <h2>Nuestra Carta Digital</h2>
                </div>
                <a href="${pageContext.request.contextPath}/cliente/carrito" style="position: relative;">
                    <span style="font-size: 1.6rem; cursor: pointer;">🛒</span>
                    <span id="cartCountBadge" class="badge badge-danger" style="position: absolute; top: -8px; right: -8px; font-size: 0.65rem; padding: 0.2rem 0.4rem;">0</span>
                </a>
            </div>

            <div class="page-body">
                <!-- Buscador e Info de Categorías -->
                <div class="menu-filter-section">
                    <input type="text" id="menuSearch" oninput="filtrarPlatos()" class="form-control menu-search-input" placeholder="🔍 ¿Qué se te antoja hoy?">
                    
                    <div class="categories-scroll">
                        <span class="category-tab active" onclick="filtrarCategoria('TODOS', this)">Todas las Especialidades</span>
                        <c:forEach var="cat" items="${categorias}">
                            <span class="category-tab" onclick="filtrarCategoria('${cat.nombre}', this)">${cat.nombre}</span>
                        </c:forEach>
                    </div>
                </div>

                <!-- Grilla de Platos -->
                <div class="menu-grid" id="platosGrid">
                    <c:forEach var="p" items="${productos}">
                        <div class="menu-card" data-nombre="${p.nombre.toLowerCase()}" data-categoria="${p.categoria.nombre}">
                            <img src="${not empty p.imagenUrl ? p.imagenUrl : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'}" 
                                 alt="${p.nombre}" class="menu-card-img">
                            <div class="menu-card-content">
                                <span class="badge badge-info" style="width: max-content; margin-bottom: 0.5rem; font-size: 0.65rem;">
                                    ${p.categoria.nombre}
                                </span>
                                <h3 class="menu-card-title">${p.nombre}</h3>
                                <p class="menu-card-desc">${p.descripcion}</p>
                                
                                <div class="menu-card-footer">
                                    <span class="price-tag">$${p.precio}</span>
                                    <button class="add-cart-btn" onclick="agregarAlCarrito(${p.id}, '${p.nombre}', ${p.precio}, '${p.imagenUrl}')">
                                        Agregar ➕
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Carrito Flotante -->
    <a href="${pageContext.request.contextPath}/cliente/carrito" class="cart-floating-badge">
        🛒
        <span id="floatingCartCount" class="cart-count">0</span>
    </a>

    <script>
        // Sistema de Carrito en LocalStorage para persistencia e interactividad ultra-rápida
        function obtenerCarrito() {
            const cartStr = localStorage.getItem('gourmetflow_cart');
            return cartStr ? JSON.parse(cartStr) : [];
        }

        function guardarCarrito(carrito) {
            localStorage.setItem('gourmetflow_cart', JSON.stringify(carrito));
            actualizarBadges();
        }

        function agregarAlCarrito(id, nombre, precio, imagen) {
            let carrito = obtenerCarrito();
            let item = carrito.find(x => x.id === id);
            
            if (item) {
                item.cantidad += 1;
            } else {
                carrito.push({
                    id: id,
                    nombre: nombre,
                    precio: precio,
                    imagen: imagen,
                    cantidad: 1
                });
            }
            
            guardarCarrito(carrito);
            
            // Animación sutil de confirmación
            alert('¡' + nombre + ' agregado al carrito!');
        }

        function actualizarBadges() {
            const carrito = obtenerCarrito();
            const totalItems = carrito.reduce((sum, x) => sum + x.cantidad, 0);
            
            document.getElementById('cartCountBadge').innerText = totalItems;
            document.getElementById('floatingCartCount').innerText = totalItems;
        }

        // Filtros del menú
        let categoriaSeleccionada = 'TODOS';
        
        function filtrarCategoria(categoria, element) {
            categoriaSeleccionada = categoria;
            
            // Quitar clase activa
            document.querySelectorAll('.category-tab').forEach(x => x.classList.remove('active'));
            element.classList.add('active');
            
            aplicarFiltros();
        }
        
        function filtrarPlatos() {
            aplicarFiltros();
        }
        
        function aplicarFiltros() {
            const query = document.getElementById('menuSearch').value.toLowerCase().trim();
            const cards = document.querySelectorAll('.menu-card');
            
            cards.forEach(card => {
                const nombre = card.getAttribute('data-nombre');
                const categoria = card.getAttribute('data-categoria');
                
                const coincideQuery = nombre.includes(query);
                const coincideCat = (categoriaSeleccionada === 'TODOS' || categoria === categoriaSeleccionada);
                
                if (coincideQuery && coincideCat) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Carga inicial de contadores
        document.addEventListener('DOMContentLoaded', actualizarBadges);
    </script>
</body>
</html>
