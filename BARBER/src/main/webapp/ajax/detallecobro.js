 $(document).ready(function () {
    rellenaridclientes();

    function rellenaridclientes() {
        $.ajax({
            data: {listar: 'buscaralumno'},
            url: 'jsp/buscadordetallecobro.jsp',
            type: 'post',
            success: function (response) {
                $("#id_cliente").html(response);
            },
            error: function (xhr, status, error) {
                console.error('Error al rellenar los clientes:', error);
            }
        });
    }

    $("#id_cliente").change(function () {
        var clienteId = $(this).val();
        console.log("Cliente ID seleccionado: ", clienteId); // Verifica el ID seleccionado
        if (clienteId) {
            clienteId = clienteId.split(',')[0];
            console.log("Cliente ID para cargar cuenta pendiente: ", clienteId); // Verifica el ID para la cuenta pendiente
            cargarCuentaPendiente(clienteId);
        } else {
            console.error("No se seleccionó ningún cliente.");
        }
    });

    function cargarCuentaPendiente(clienteId) {
        console.log("Cargando cuenta pendiente para cliente ID: ", clienteId); // Verifica que se llame correctamente
        $.ajax({
            data: {listar: 'cargarcuentapendiente', clienteId: clienteId},
            url: 'jsp/buscadordetallecobro.jsp',
            type: 'post',
            success: function (response) {
                console.log("Respuesta de la cuenta pendiente: ", response); // Verifica la respuesta
                $("#resultados").html(response);
            },
            error: function (xhr, status, error) {
                console.error('Error al cargar la cuenta pendiente:', error);
            }
        });
}




    function cargarCuentaPendiente(clienteId) {
        $.ajax({
            data: {listar: 'cargarcuentapendiente', clienteId: clienteId},
            url: 'jsp/buscadordetallecobro.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response);
            }
        });
    }


    $("#btn-cancelar").click(function () {
        $.ajax({
            data: {listar: 'cancelarcobro'},
            url: 'jsp/buscadordetallecobro.jsp',
            type: 'post',
            success: function () {
                location.href = 'cobros.jsp';
            }
        });
    });

    $("#btn-finalizar").click(function () {
      var datosform = $("#form").serialize();
      console.log("Datos del formulario: ", datosform); // Verifica los datos a enviar
      $.ajax({
          data: datosform,
          url: 'jsp/buscadordetallecobro.jsp',
          type: 'POST',
          success: function (response) {
              console.log("Respuesta del servidor: ", response); // Verifica la respuesta del servidor
              location.href = 'cobros.jsp';
          },
          error: function (xhr, status, error) {
              console.error("Error en la solicitud AJAX: ", status, error);
          }
      });
    });


});
function dividirclientes(a) {
    //  alert(a);
    datos = a.split(',');
    $("#id_cliente").val(datos[0]);
    $("#ci").val(datos[1]);

}
