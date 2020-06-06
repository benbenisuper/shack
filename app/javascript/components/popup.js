const initClosePopupOnClick = () => {
	$('#thankModal').modal('show');
	// pf_modal = document.querySelector('.static-popup-link')
	$('#pf_info_link').on('click', function(){
      $('#pagoFacilModal').modal('show');
    });
    $('#transfer_info_link').on('click', function(){
      $('#transferModal').modal('show');
    });
}

export { initClosePopupOnClick };