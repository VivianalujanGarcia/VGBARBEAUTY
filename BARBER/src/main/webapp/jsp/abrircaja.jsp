<%@ include file="conexion.jsp" %>

<%    
    HttpSession sesion = request.getSession();
    int idusuario = 0;

    // Verifica si el atributo de sesión "idusuario" existe y no es nulo
    if (sesion.getAttribute("id") != null) {
        idusuario = Integer.parseInt(sesion.getAttribute("id").toString());
    } else {
        out.print("Usuario no autenticado. Por favor, inicie sesión.");
        return;
    }

    String fecha = request.getParameter("fecha");
    String monto = request.getParameter("monto");

    Statement st = null;
    ResultSet rs = null;

    try {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT id FROM abrircaja WHERE estado='ABIERTO'");
        
        if (!rs.next()) {
            String sql = "INSERT INTO abrircaja (fecha, monto, estado, idusuario) VALUES ('" + fecha + "', '" + monto + "', 'ABIERTO', '" + idusuario + "')";
            st.executeUpdate(sql);
            out.print("Caja abierta exitosamente");
        } else {
            out.print("DEBE CERRAR CAJA PARA APERTURA");
        }
    } catch (SQLException e) {
        out.print("Error al abrir la caja: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
        } catch (SQLException e) {
            out.print("Error al cerrar los recursos: " + e.getMessage());
        }
    }
%>
