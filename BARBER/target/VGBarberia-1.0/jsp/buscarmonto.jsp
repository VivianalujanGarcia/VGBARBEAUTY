<%@include file="conexion.jsp" %>
<%
    HttpSession sesion = request.getSession();
    try {
        // Obtener el ID del usuario desde la sesión como String
        String usuarioStr = (String) sesion.getAttribute("id");

        if (usuarioStr != null && !usuarioStr.isEmpty()) {
            // Convertir el ID de usuario a Integer
            Integer usuarioId = Integer.parseInt(usuarioStr);

            // Preparar la consulta SQL
            String query = "SELECT ape_monto FROM aperturas WHERE idusuarios = ? AND ape_estado = 'ABIERTA' ORDER BY idaperturas DESC LIMIT 1";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, usuarioId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Integer idApertura = rs.getInt("ape_monto");
                if (idApertura != null) {
                    out.print(idApertura);
                } else {
                    out.print("");
                }
            } else {
                out.print("");
            }
        } else {
            out.print("");
        }
    } catch (NumberFormatException e) {
        out.println("Error en el formato del parámetro 'id': " + e.getMessage());
    } catch (SQLException e) {
        out.println("Error SQL: " + e.getMessage());
    } catch (Exception e) {
        out.println("Error general: " + e.getMessage());
    }
%>
