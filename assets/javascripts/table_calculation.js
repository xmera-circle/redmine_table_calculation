/* Redmine Table Calculation
   Copyright (C) 2021  Liane Hampe, xmera */

function coloredSpreadsheetEnumerationBadge() {
  $('td.name').each(function () {
    var color = $(this).data('color');
    var value = $(this).text();
    if (color) {
      $(this).empty().html(
        `<table class='enumeration-badge'>
          <tbody>
            <tr>
              <td style="background-color: `+ color + `;" title="` + value + ` "></td>
            </tr>
          </tbody>
        </table>`
      )
    }
  });
}
$(document).ready(coloredSpreadsheetEnumerationBadge);