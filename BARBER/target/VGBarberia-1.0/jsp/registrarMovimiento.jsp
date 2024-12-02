<%@ include file="conexion.jsp" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.SQLException, java.sql.Statement, java.sql.ResultSet" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // Obtener los parámetros del formulario
    String tipo_movimiento = request.getParameter("tipo_movimiento");
    String monto = request.getParameter("monto");
    String descripcion = request.getParameter("descripcion");
    String idabrircaja = request.getParameter("idabrircaja");

    // Definir la conexión a la base de datos

    Statement st = null;
    ResultSet rs = null;

    try {
        // Establecer la conexión
      

        // Verificar si hay una caja abierta
        st = conn.createStatement();
        rs = st.executeQuery("SELECT id FROM abrircaja WHERE estado='ABIERTO' LIMIT 1");

        int idabrir = -1;
        if (rs.next()) {
            idabrir = rs.getInt("id");
        }

        // Si no hay caja abierta, mostrar un error
        if (idabrir == -1) {
            out.print("No se puede registrar el movimiento, la caja no está abierta.");
            return;
        }

        // Registrar el movimiento en la base de datos
        String sql = "INSERT INTO movimientocaja (tipo_movimiento, monto, descripcion, idabrircaja) " +
                     "VALUES ('" + tipo_movimiento + "', '" + monto + "', '" + descripcion + "', " + idabrircaja + ")";
        st.executeUpdate(sql);

        out.print("Movimiento registrado exitosamente.");

    } catch (SQLException e) {
        out.print("Error al registrar el movimiento: " + e.getMessage());
    } finally {
        // Cerrar los recursos
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.print("Error al cerrar los recursos: " + e.getMessage());
        }
    }
%>
