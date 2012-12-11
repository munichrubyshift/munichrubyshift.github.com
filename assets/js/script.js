$( function()
  {    
    // topnav click event
    $('ul.nav a, #brand, .button-black' ).bind( 'click',
      function( event )
      {
        var that = $( this );

        $( '[data-spy="scroll"]' ).each( 
        function()
        {
          var spy = $( this ).scrollspy( 'refresh' )
        } );
        
        var offset = 140;
        
        // if window width is smaller than 979px, don't add offset
        if( $( window ).width() < 979 )
        {
          offset = 0;
        }

        $( 'html, body' ).stop().animate(
        {
          scrollTop: $( that.attr( 'href' ) ).offset().top - offset
        },
        1000,
        'easeInOutExpo'
        );

        event.preventDefault();
      } );
  } );
  
function contact_send()
{
  contact_data = new Object();
  contact_data.name = $( '#contact-form input[name="name"]' ).val();
  contact_data.email = $( '#contact-form input[name="email"]' ).val();
  contact_data.message = $( '#contact-form textarea[name="message"]' ).val();
  
  // validation
  if( contact_data.name == '' )
  {
    $( '#contact-form input[name="name"]' ).addClass( 'error' );
    return false;
  }
  else
  {
    $( '#contact-form input[name="name"]' ).removeClass( 'error' );
  }
  
  if( contact_data.email == '' || !/^[a-zA-Z0-9_\.\-]+\@([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9]{2,4}$/.test( contact_data.email ) )
  {
    $( '#contact-form input[name="email"]' ).addClass( 'error' );
    return false;
  }
  else
  {
    $( '#contact-form input[name="email"]' ).removeClass( 'error' );
  }
  
  if( contact_data.message == '' )
  {
    $( '#contact-form textarea[name="message"]' ).addClass( 'error' );
    return false;
  }
  else
  {
    $( '#contact-form textarea[name="message"]' ).removeClass( 'error' );
  }
  
  // e-mail send via AJAX
  $.ajax(
  {
    type: 'POST',
    url: 'ajax_contact.php',
    data: 'name=' + contact_data.name + '&email=' + contact_data.email + '&message=' + contact_data.message,
    success: function()
    {
      $( '#contact-form input[name="name"]' ).val( '' );
      $( '#contact-form input[name="email"]' ).val( '' );
      $( '#contact-form textarea[name="message"]' ).val( '' );
      $( '#contact-form input[type="submit"]' ).fadeOut( 'slow', function()
      {
        $( '#contact-form input[type="submit"]' ).css( 'background-image', 'none' );
        $( '#contact-form input[type="submit"]' ).val( 'SENT' );
        $( '#contact-form input[type="submit"]' ).fadeIn( 'slow' );
        setTimeout( function()
        {
          $( '#contact-form input[type="submit"]' ).fadeOut( 'slow', function()
          {
            $( '#contact-form input[type="submit"]' ).css( 'background-image', '' );
            $( '#contact-form input[type="submit"]' ).val( '' );
            $( '#contact-form input[type="submit"]' ).fadeIn( 'slow' );
          } );
        },
        3000 );
      } );
    }
  } );
}