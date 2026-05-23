<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Sistema Restaurante</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="login-container">
        <!-- Lado Izquierdo: Branding Visual -->
        <div class="login-sidebar">
            <div class="login-sidebar-content">
                <h1>Sabores únicos, servicio excepcional.</h1>
                <p>Gestiona el inventario, atiende comandas y realiza pedidos digitales en nuestra plataforma todo en uno para restaurantes modernos.</p>
            </div>
        </div>

        <!-- Lado Derecho: Formulario de Login -->
        <div class="login-form-side">
            <div class="login-box">
                <div class="login-logo">
                    🍔 <span>GourmetFlow</span>
                </div>
                <h2>¡Bienvenido de nuevo!</h2>
                <p class="subtitle">Por favor ingresa tus datos de acceso.</p>

                <!-- Despliegue de Errores de Validación -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <span>⚠️ ${error}</span>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'eliminado' || param.msg == 'guardado'}">
                    <div class="alert alert-success">
                        <span>Acción realizada correctamente.</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="form-group">
                        <label for="email">Correo Electrónico</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="ejemplo@restaurante.com" required value="${param.email}">
                    </div>
                    <div class="form-group">
                        <label for="password">Contraseña</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">
                        Ingresar al Sistema
                    </button>
                </form>

                <div style="margin-top: 2rem; border-top: 1px solid #edf2f7; padding-top: 1.5rem; text-align: center;">
                    <p style="font-size: 0.85rem; color: #a0aec0;">Cuentas de prueba:</p>
                    <p style="font-size: 0.8rem; color: #4a5568; margin-top: 0.25rem;">
                        <strong>Admin:</strong> admin@restaurante.com (admin123)<br>
                        <strong>Trabajador:</strong> worker@restaurante.com (worker123)<br>
                        <strong>Cliente:</strong> client@restaurante.com (client123)
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
