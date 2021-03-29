(function() {
  jQuery(function() {
    var cities;
    cities = $('#user_city_id').html();
    return $('#user_province_id').change(function() {
      var options, province;
      province = $('#user_province_id :selected').text();
      options = $(cities).filter("optgroup[label='" + province + "']").html();
      if (options) {
        return $('#user_city_id').html(options);
      } else {
        return $('#user_city_id').empty();
      }
    });
  });

}).call(this);
