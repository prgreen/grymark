$ = jQuery

$ ->
  $('#bitcoindonate').css('cursor', 'pointer')
  $('#bitcoindonate').click(()->
    prompt 'Send bitcoin donations to this address:', '1Gt1tLerARuJbWegQtdpWrMMaDL6FEYqGf'
    )