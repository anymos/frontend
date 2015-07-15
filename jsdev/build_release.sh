#!/bin/bash

#############################################
# remove all compiled soy templates
#############################################
rm -rf ./bitex/templates/*.soy.js
rm -rf ./bitex/ui/*.soy.js

#############################################
# set defaults if they're not provided
#############################################
LANG=${LANG:=en_US}
THEME=${THEME:=default}

#############################################
# compile soy templates
#############################################

SOY_TEMPLATES="
               templates/templates
               ui/deposit_withdraw_button_group
               ui/bitex_datagrid
               ui/bitex_listview
               ui/order_book
               ui/simple_chart
               ui/withdraw_methods
               ui/withdraw_method_editor
               ui/advanced_order_entry
               ui/simple_order_entry
               ui/market_view_table
               ui/change_password
               ui/algorithm_selector
               ui/algorithm_runner
               ui/locked_balance_display
               ui/remittance_box
               ui/api_key_data_entry
               ui/dialog
               view/line_of_credit
"

for template in $SOY_TEMPLATES ; do 
    echo -n "$template.$THEME.soy -> "
    java -jar ./tools/SoyToJsSrcCompiler.jar --bidiGlobalDir 1 --shouldGenerateGoogMsgDefs \
      --shouldProvideRequireSoyNamespaces --codeStyle concat --cssHandlingScheme GOOG  \
      --outputPathFormat  "./bitex/${template}.soy.js" \
      ./bitex/$template.$THEME.soy
    echo "$template.soy.js"
done


echo "done with soy templates"

## Messages - Uncomment this to generate the translation file
#python ./closure-library/closure/bin/build/closurebuilder.py  \
#  --root=./bitex \
#  --root=./closure-library/ \
#  --root=./closure-bootstrap/javascript/ \
#  --root=./scottlogic/ \
#  --root=./uniform/ \
#  --namespace=bitex.app.BlinkTrade \
#  --output_mode=compiled \
#  --compiler_jar=./tools/XtbGenerator.jar \
#  --compiler_flags="--lang=$LANG" \
#  --compiler_flags="--translations_file=./translations/$LANG.xtb.xml" \
#  --compiler_flags="--xtb_output_file=./translations/$LANG.xtb.xml"


# BlinkTrade Application - enUS
python ./closure-library/closure/bin/build/closurebuilder.py  \
  --root=./closure-library/ \
  --root=./closure-bootstrap/javascript/ \
  --root=./scottlogic/ \
  --root=./uniform/ \
  --root=./expression_evaluator/ \
  --root=./bitex \
  --namespace=bitex.app.BlinkTrade \
  --output_mode=compiled \
  --compiler_jar=./tools/compiler.jar \
  --compiler_flags="--compilation_level=ADVANCED_OPTIMIZATIONS" \
  --compiler_flags="--define=goog.DEBUG=0" \
  --compiler_flags="--define=goog.LOCALE='$LANG'" \
  --compiler_flags="--externs=./externs/google.js" \
  --compiler_flags="--externs=./externs/plusone.js" \
  --compiler_flags="--externs=./externs/zopim.js" \
  --compiler_flags="--externs=./externs/jquery-1.9.js" \
  --compiler_flags="--externs=./externs/twitter-bootstrap.js" \
  --compiler_flags="--externs=./externs/google_analytics_api.js" \
  --compiler_flags="--externs=./externs/parsley.js" \
  --compiler_flags="--externs=./externs/jquerymobile-1.4.3.js" \
  --compiler_flags="--externs=./externs/sticky.js" \
  --compiler_flags="--externs=./externs/socket.io.js" \
  --compiler_flags="--externs=./externs/w3c_rtc.js" \
  --compiler_flags="--externs=./externs/facebook_javascript_sdk.js" \
  --compiler_flags="--translations_file=./translations/$LANG.xtb.xml" \
  --compiler_flags="--debug=TRUE" \
  --compiler_flags="--formatting=PRETTY_PRINT" \
  --compiler_flags="--formatting=PRINT_INPUT_DELIMITER" \
   > ../assets/js/bitex_app_blink_trade.compiled.$LANG.$THEME.js

# enable those flags to debug the compiled code.
#  --compiler_flags="--debug=TRUE" \
#  --compiler_flags="--formatting=PRETTY_PRINT" \
#  --compiler_flags="--formatting=PRINT_INPUT_DELIMITER" \

