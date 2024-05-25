class AutoCompleteModel
{
  String status;
  List<Prediction> predictions;
  
  AutoCompleteModel({
    required this.status,
    required this.predictions,
});
  
  factory AutoCompleteModel.fromJson(Map<String,dynamic> placeData)
  {
    return AutoCompleteModel(
        status: placeData['status'],
        predictions: (placeData['predictions'] as List<dynamic>)
            .map((e) => Prediction.fromJson(e))
            .toList(),
    );
  }

}

class Prediction
{
  String description;
  String placeId;

  Prediction({required this.description,required this.placeId});

  factory Prediction.fromJson(Map<String ,dynamic> predictionInfo)
  {
    return Prediction(
        description: predictionInfo['description'],
        placeId: predictionInfo['place_id']
    );
  }
}