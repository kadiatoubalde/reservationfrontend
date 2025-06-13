class SearchTrajetDto {
    String departId;
    String arriveId;
    LocalDate dateDepart;
    LocalTime timeDepart;

    SearchTrajetDto({required this.departId, required this.arriveId, required this.dateDepart, required this.timeDepart});

    factory SearchTrajetDto.fromJson(Map<String, dynamic> json) {
        return SearchTrajetDto(
            departId: json['departId'],
            arriveId: json['arriveId'],
            dateDepart: json['dateDepart'],
            timeDepart: json['timeDepart'],
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'departId': departId,
            'arriveId': arriveId,
            'dateDepart': dateDepart,
            'timeDepart': timeDepart,
        };
    }
}