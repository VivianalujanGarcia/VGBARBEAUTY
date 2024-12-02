<%@include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<script src="ajax/ajusteinventario.js"></script>
<%
    // Obtener la fecha actual
    Date fechaActual = new Date();

    // Crear un formateador de fecha
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");

    // Formatear la fecha
    String fechaFormateada = formateadorFecha.format(fechaActual);
    String usuario = (String) session.getAttribute("usuario");
   
%>


    <title>Inventario</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background:  #FFFFFF; /* Fondo similar al de la captura */
            background-size: cover;
            color: white;
        }

        .container {
            max-width: 900px;
            margin: 20px auto; /* Ajusta el margen superior aquí */
            padding: 20px;
            background-color:  #FFFFFF;
            border-radius: 10px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input, .form-group select {
            width: calc(100% - 20px);
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #333;
            color: white;
        }

        .form-group input[readonly] {
            background-color:    #444;
        }

        .buttons {
            display: flex;
            justify-content: space-between;
        }

        .buttons button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .buttons .primary {
            background-color: #007bff;
            color: white;
        }

        .buttons .secondary {
            background-color: #6c757d;
            color: white;
        }

        .buttons .danger {
            background-color: #dc3545;
            color: white;
        }

        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            background-color: #333;
            color: white;
        }

        table th, table td {
            padding: 10px;
            border: 1px solid #555;
            text-align: left;
        }

        table th {
            background-color:    #444;
        }

        table td input {
            width: 100%;
            padding: 8px;
            border: none;
            background-color: #333;
            color: white;
        }

    </style>
</head>
<body>
    <div class="container">
        <h1>Inventario de Productos</h1>
           <input type="hidden" id="listar" name="listar" value="cargar"/>
        <div class="form-group">
            <label for="ajuste">Ajuste N°</label>
            <input type="text" id="idajusteinve" name="idajusteinve" readonly>
        </div>
<div class="form-group">
            <label for="ajuste">Usuario </label>
             <input type="hidden" id="idusuarios" name="idusuarios" value="<% out.print(sesion.getAttribute("dato")); %>" readonly>
                    
        </div>
        <div class="form-group">
            <label for="fecha">Fecha</label>
           <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" onKeyUp="" autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada%>" readonly>
        </div>

        <div class="form-group">
            <label for="estado">Tipo</label>
            <input type="text" id="estado" name="estado" value="PENDIENTE" readonly>
        </div>

        <div class="form-group">
            <label for="producto">Producto</label>
            <input type="hidden" id="codproducto" name="codproducto">
            <select class="form-control" name="idproductos" id="idproductos" onchange="dividirproducto(this.value)">

            </select>
        </div>

        <div class="form-group">
            <label for="motivo">Motivo</label>
            <select id="motivo">
                <option value="descontar">DESCONTAR</option>
                <option value="aumentar">AUMENTAR</option>
            </select>
        </div>
        <div class="form-group">
            <label for="cantidad">Cantidad ajuste</label>
            <input  class="form-control"  type="number" id="cant_ajuste"  name="cant_ajuste" value="">
        </div>
        <div align="right">
            <button type="button" name="agregar" value="agregar" id="AgregaProductoAjuste" class="btn btn-primary" onclick=""><span class="mdi mdi-cart-plus"></span> Agregar</button>
            <div id="respuesta"></div>
        </div>
        <table>
            <thead>
                <tr>
                    <th>COD</th>
                    <th>NOMBRE</th>
                    <th>STOCK</th>
                    <th>AJUSTE</th>
                    <th>REALIZADO</th>
                    <th>MOTIVO</th>
                </tr>
            </thead>
            <tbody>
               
            </tbody>
        </table>

        <div class="modal-footer">
            <button class="btn btn-danger" type="reset" onclick="#" id="btn-cancelar"><span class="mdi mdi-cancel"></span> Cancelar</button>
            <button type="button" name="btn-submit" id="btn-finalizar" class="btn btn-primary" onclick="#"><span class="mdi mdi-note-plus-outline"></span> Registrar</button>
        </div>

    </div>

<%@include file="footer.jsp" %>