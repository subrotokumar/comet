class TransactionModel {
  late String blockNumber;
  late String blockHash;
  late String timeStamp;
  late String hash;
  late String nonce;
  late String transactionIndex;
  late String from;
  late String to;
  late String gas;
  late String gasPrice;
  late String input;
  late String methodId;
  late String functionName;
  late String contractAddress;
  late String cumulativeGasUsed;
  late String txreceiptStatus;
  late String gasUsed;
  late String confirmations;
  late String isError;
  late String value;
  TransactionModel({
    required this.blockNumber,
    required this.blockHash,
    required this.timeStamp,
    required this.hash,
    required this.nonce,
    required this.transactionIndex,
    required this.from,
    required this.to,
    required this.gas,
    required this.gasPrice,
    required this.input,
    required this.methodId,
    required this.functionName,
    required this.contractAddress,
    required this.cumulativeGasUsed,
    required this.txreceiptStatus,
    required this.gasUsed,
    required this.confirmations,
    required this.isError,
    required this.value,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      blockNumber: map['blockNumber'] ?? '',
      blockHash: map['blockHash'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
      hash: map['hash'] ?? '',
      nonce: map['nonce'] ?? '',
      transactionIndex: map['transactionIndex'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      gas: map['gas'] ?? '',
      gasPrice: map['gasPrice'] ?? '',
      input: map['input'] ?? '',
      methodId: map['methodId'] ?? '',
      functionName: map['functionName'] ?? '',
      contractAddress: map['contractAddress'] ?? '',
      cumulativeGasUsed: map['cumulativeGasUsed'] ?? '',
      txreceiptStatus: map['txreceiptStatus'] ?? '',
      gasUsed: map['gasUsed'] ?? '',
      confirmations: map['confirmations'] ?? '',
      isError: map['isError'] ?? '',
      value: map['value'] ?? '',
    );
  }

  @override
  String toString() {
    return 'TransactionModel(blockNumber: $blockNumber, blockHash: $blockHash, timeStamp: $timeStamp, hash: $hash, nonce: $nonce, transactionIndex: $transactionIndex, from: $from, to: $to, gas: $gas, gasPrice: $gasPrice, input: $input, methodId: $methodId, functionName: $functionName, contractAddress: $contractAddress, cumulativeGasUsed: $cumulativeGasUsed, txreceiptStatus: $txreceiptStatus, gasUsed: $gasUsed, confirmations: $confirmations, isError: $isError)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.blockNumber == blockNumber &&
        other.blockHash == blockHash &&
        other.timeStamp == timeStamp &&
        other.hash == hash &&
        other.nonce == nonce &&
        other.transactionIndex == transactionIndex &&
        other.from == from &&
        other.to == to &&
        other.gas == gas &&
        other.gasPrice == gasPrice &&
        other.input == input &&
        other.methodId == methodId &&
        other.functionName == functionName &&
        other.contractAddress == contractAddress &&
        other.cumulativeGasUsed == cumulativeGasUsed &&
        other.txreceiptStatus == txreceiptStatus &&
        other.gasUsed == gasUsed &&
        other.confirmations == confirmations &&
        other.isError == isError &&
        other.value == value;
  }

  @override
  int get hashCode {
    return blockNumber.hashCode ^
        blockHash.hashCode ^
        timeStamp.hashCode ^
        hash.hashCode ^
        nonce.hashCode ^
        transactionIndex.hashCode ^
        from.hashCode ^
        to.hashCode ^
        gas.hashCode ^
        gasPrice.hashCode ^
        input.hashCode ^
        methodId.hashCode ^
        functionName.hashCode ^
        contractAddress.hashCode ^
        cumulativeGasUsed.hashCode ^
        txreceiptStatus.hashCode ^
        gasUsed.hashCode ^
        confirmations.hashCode ^
        isError.hashCode ^
        value.hashCode;
  }
}
