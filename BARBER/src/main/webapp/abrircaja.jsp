<%@ include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<script src="ajax/abrircaja.js"></script>

<%
    // Obtener la fecha actual
    Date fechaActual = new Date();

    // Crear un formateador de fecha
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");

    // Formatear la fecha
    String fechaFormateada = formateadorFecha.format(fechaActual);

    // Obtener el usuario de la sesión (suponiendo que el usuario está almacenado en la sesión)
    String usuario = (String) session.getAttribute("usuario");
%>
<html>
<head>
    <title>Apertura de Caja</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            background-color: #28a745;
        }
        .btn:hover {
            background-color: #218838;
        }
        .alert {
            margin-top: 20px;
            padding: 15px;
            border-radius: 4px;
            color: white;
        }
        .alert-success {
            background-color: #28a745;
        }
        .alert-danger {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Apertura de Caja</h1>
        <form id="form">
               <input type="hidden" id="listar" name="listar" value="cargar"/>
            <div class="form-group">
                <label for="fecha">Fecha:</label>
                <input type="text" id="fecha" name="fecha" value="<%= fechaFormateada %>" readonly>
            </div>
            <div class="form-group">
                <label for="usuario">Usuario:</label>
                <input type="text" id="idusuario" name="idusuario" value="<% out.print(sesion.getAttribute("dato")); %>" readonly>
                    
            </div>
            <div class="form-group">
                <label for="monto">Monto Inicial en Caja:</label>
                <input type="number" id="monto" name="monto" required>
            </div>
            <input type="button" id="abrircaja" class="btn" value="Abrir Caja">
        </form>
        <div id="mensajeAlerta" class="alert" style="display: none;"></div>
    </div>

   

<%@ include file="footer.jsp" %>
