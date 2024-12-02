$(document).ready(function () {
    
    // Detectar el cambio en el método de pago
    $("#metodoModal").change(function () {
        var metodo = $(this).val();
        var montoTotal = calcularMontoTotal(); // Calculamos el monto total dinámicamente
        
        console.log("Monto total:", montoTotal); // Para depuración

        // Verificar si el monto total está definido
        if (metodo === "QR") {
            if (!montoTotal || montoTotal == 0) {
                mostrarMensaje("El monto total no está definido o es 0.", "danger");
                return; // No continuar si el monto no está disponible
            }

            // Generar el QR dinámicamente
            $("#qrCode").empty(); // Limpiar cualquier QR anterior
            new QRCode(document.getElementById("qrCode"), {
                text: `Monto: ${montoTotal} Gs`, // El monto es el que se pasa al escanear
                width: 200,
                height: 200
            });
            $("#qrSection").show(); // Mostrar la sección QR
        } else {
            $("#qrSection").hide(); // Ocultar la sección QR si no es seleccionado
            $("#qrCode").empty();
        }
    });

    // Función para calcular el monto total
    function calcularMontoTotal() {
        let total = 0;
        let cuentas = document.querySelectorAll(".cuentas:checked"); // Selecciona las cuentas marcadas
        cuentas.forEach(function (cuenta) {
            total += parseFloat(cuenta.getAttribute("data-monto")); // Asume que 'data-monto' contiene el valor del monto
        });
        $("#montoTotal").val(total.toFixed(2)); // Guardamos el monto total en un campo hidden
        return parseInt(total.toFixed(2)); // Retorna el total con 2 decimales
    }

    // Enviar la solicitud AJAX con el método de pago y el monto total
    $("#formAgregarMetodo").on("submit", function (e) {
        e.preventDefault();

        let metodo = $("#metodoModal").val();
        let banco = $("#bancoModal").val();
        let montoTotal = $("#montoTotal").val(); // Obtener el monto total calculado

        if (metodo && banco) {
            $.ajax({
                data: {
                    listar: 'finalizar',
                    id_cliente: $("#codalumno").val(),
                    metodo_pago: metodo,
                    banco: banco,
                    monto_total: montoTotal // Mandar el monto total al servidor
                },
                url: 'jsp/buscadordetallecobro.jsp',
                type: 'post',
                success: function (response) {
                    location.href = 'cobros.jsp'; // Redirigir después del proceso
                },
                error: function (xhr, status, error) {
                    mostrarMensaje("Hubo un error al procesar la solicitud. Intenta nuevamente.", "danger");
                }
            });

            // Ocultar el modal después de enviar
            $("#agregarMetodoModal").modal("hide");
        } else {
            mostrarMensaje("Por favor, complete todos los campos del método de pago.", "warning");
        }
    });
    
    // Función para mostrar el mensaje
    function mostrarMensaje(texto, tipo) {
        // Limpiar cualquier mensaje anterior
        $("#mensaje").removeClass().addClass("alert alert-" + tipo).text(texto).show();
        
        // Ocultar el mensaje después de 5 segundos
        setTimeout(function() {
            $("#mensaje").fadeOut();
        }, 5000);
    }

    function dividirCuenta(selectedAccounts) {
        if (selectedAccounts) {
            var cuentas = selectedAccounts.split(',');
            var montoTotal = 0;

            cuentas.forEach(function(cuentaId) {
                var checkbox = document.querySelector(`.cuentas[value='${cuentaId}']`);
                if (checkbox && checkbox.checked) {
                    var monto = parseFloat(checkbox.getAttribute('data-monto'));
                    if (!isNaN(monto)) {
                        montoTotal += monto;
                    }
                }
            });

            $("#montoTotal").val(montoTotal.toFixed(2)); // Asignar el valor al campo oculto
        }
    }

    // Llamar a dividirCuenta cuando se cambie el estado de los checkboxes
    $(document).on('change', '.cuentas', function() {
        var cuentasSeleccionadas = [];
        $('.cuentas:checked').each(function() {
            cuentasSeleccionadas.push($(this).val()); // Almacenar el ID de la cuenta
        });

        dividirCuenta(cuentasSeleccionadas.join(',')); // Llamar con las cuentas seleccionadas
    });
});
 