String windowSizeFormatter(windowSizeLabel) {
  var windowSize = "1d";
  switch (windowSizeLabel) {
    case '1 Hour':
      windowSize = '1h.';
      break;
    case '24 Hours':
      windowSize = '1d';
      break;
    case '7 Days':
      windowSize = '7d';
      break;
  }

  return windowSize;
}
