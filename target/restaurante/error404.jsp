<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página No Encontrada</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-layout {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            text-align: center;
            background-color: #f8fafc;
            padding: 2rem;
        }
        .error-card {
            background-color: white;
            padding: 4rem 3rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            max-width: 500px;
            border: 1px solid #e2e8f0;
        }
        .error-icon {
            font-size: 5rem;
            margin-bottom: 1.5rem;
        }
        .error-card h1 {
            font-size: 2.2rem;
            font-weight: 800;
            color: hsl(var(--primary));
            margin-bottom: 1rem;
        }
        .error-card p {
            color: #64748b;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <div class="error-layout">
        <div class="error-card">
            <div class="error-icon">🕵️‍♂️</div>
            <h1>Error 404</h1>
            <p>La página o el platillo que estás buscando no existe en nuestro menú. Asegúrate de verificar la URL ingresada.</p>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                Volver al Inicio
            </a>
        </div>
    </div>
</body>
</html>
