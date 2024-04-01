$(function() {
	'use strict';
});

$(document).on('click', '#iniciar-sesion', function() {
	$.ajax({
		url: '../controllers/loginController.php',
		type: 'POST',
		data: { action: 'prueba', data: 'Pruebaxx' },
		dataType: 'JSON',
		beforeSend: function() {

		},
		success: function(data) {
			alert('chido!');
			console.log(data);
		},
		error: function(error) {
			alert('VALIO QUESO!');
			console.log(error);
		},
	});
});