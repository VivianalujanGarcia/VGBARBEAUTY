$(document).ready(function () {
    listadomovimientoajax();


    function listadomovimientoajax() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/movimientocaja.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response);
            }
        });
    
    }

});
