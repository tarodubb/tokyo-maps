function getMax(features, prop) {
  var max;
  for (var i=0 ; i<features.length ; i++) {
      if (max == null || parseInt(features[i]["properties"][prop]) > parseInt(max[prop]))
          max = features[i]["properties"][prop];
  }
  return max;
}

export {getMax}
