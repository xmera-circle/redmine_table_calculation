/* Redmine Table Calculation
   Copyright (C) 2021-2023  Liane Hampe, xmera Solutions GmbH */

function coloredSpreadsheetEnumerationBadge() {
  $('td.name').each(function () {
    let color = $(this).data('color');
    let value = $(this).text();
    if (color) {
      $(this).empty().html(
        `<table class='enumeration-badge'>
          <tbody>
            <tr>
              <td style="background-color: `+ color + `;" title="` + value + `"></td>
            </tr>
          </tbody>
        </table>`
      )
    }
  });
  highlightTooltip();
}

function coloredResultSpreadsheetEnumerationBadge() {
  $('#grouped-calculation-results td.name').each(function () {
    let color = $(this).data('color');
    let value = $(this).text();
    if (color) {
      $(this).empty().html(
        `<table class='enumeration-badge'>
          <tbody>
            <tr>
              <td style="background-color: `+ color + `;" title="` + value + `"></td>
            </tr>
          </tbody>
        </table>`
      )
    }
    highlightTooltip();
  });
}

function highlightTooltip() {
  $("[title]").tooltip({
    classes: {
      "ui-tooltip": "highlight"
    }
  });
}


$(document).ready(coloredSpreadsheetEnumerationBadge);
