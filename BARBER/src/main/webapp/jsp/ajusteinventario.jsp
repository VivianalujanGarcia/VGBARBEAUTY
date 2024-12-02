<%@ include file="conexion.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    // Obtener la sesión y verificar si el usuario está autenticado
    HttpSession sesion = request.getSession();
    int idusuarios = 0;

    if (sesion.getAttribute("id") != null) {
        idusuarios = Integer.parseInt(sesion.getAttribute("id").toString());
    } else {
        out.print("<script>alert('Usuario no autenticado. Por favor, inicie sesión.'); window.location.href='login.jsp';</script>");
        return;
    }

    // Obtener los parámetros desde el request
    String fecha = request.getParameter("fecha");
    String tipo = request.getParameter("tipo");

    // Imprimir los valores de las variables para verificar que no son nulas o incorrectas
    out.println("Fecha: " + fecha);
    out.println("Tipo: " + tipo);
    out.println("ID Usuario: " + idusuarios);

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Establecer la conexión a la base de datos
        Class.forName("org.postgresql.Driver");  // Cambia el driver si es necesario
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/VGBarberia", "postgres", "1");

        // Verificar que la conexión es exitosa
        if (conn != null) {
            out.println("Conexión exitosa a la base de datos.");
        }

        // Verificar si ya existe un ajuste pendiente
        String queryVerificacion = "SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'";
        ps = conn.prepareStatement(queryVerificacion);
        rs = ps.executeQuery();

        if (!rs.next()) {
            // Si no existe un ajuste pendiente, insertar un nuevo ajuste
            String queryInsercion = "INSERT INTO ajusteinventario (fecha, tipo, estado, idusuarios) VALUES (?, ?, 'PENDIENTE', ?)";
            ps = conn.prepareStatement(queryInsercion);
            ps.setString(1, fecha);
            ps.setString(2, tipo);
            ps.setInt(3, idusuarios);

            int filasInsertadas = ps.executeUpdate();

            // Verificar si la inserción fue exitosa
            if (filasInsertadas > 0) {
                out.print("<script>alert('Ajuste de inventario guardado exitosamente.'); window.location.href='ajusteinventario.jsp';</script>");
            } else {
                out.print("<script>alert('No se insertó ninguna fila.'); window.location.href='ajusteinventario.jsp';</script>");
            }
        } else {
            // Si existe un ajuste pendiente, mostrar un mensaje de advertencia
            out.print("<script>alert('Ya existe un ajuste pendiente. Debe cerrarlo antes de crear uno nuevo.'); window.location.href='ajusteinventario.jsp';</script>");
        }
    } catch (SQLException e) {
        // Capturar y mostrar el error de SQL
        out.print("<script>alert('Error al guardar el ajuste de inventario: " + e.getMessage() + "'); window.location.href='ajusteinventario.jsp';</script>");
    } catch (ClassNotFoundException e) {
        // Capturar y mostrar el error de carga del driver
        out.print("<script>alert('Error al cargar el driver de la base de datos: " + e.getMessage() + "');</script>");
    } finally {
        // Cerrar todos los recursos
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.print("<script>alert('Error al cerrar los recursos: " + e.getMessage() + "');</script>");
        }
    }
%>
