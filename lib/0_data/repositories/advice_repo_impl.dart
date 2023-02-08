import 'package:advicer/0_data/data_sources/advice_remote_datasource.dart';
import 'package:advicer/0_data/exceptions/exceptions.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceRepoImpl implements AdviceRepo {
  final AdviceRemoteDatasource adviceRemoteDatasource =
      AdviceRemoteDatasourceImpl();
  @override
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource() async {
    try {
      final result = await adviceRemoteDatasource.getRandomAdviceFromAPI();
      return right(result);
    }on ServerException catch(_){
      return left(ServerFailure());
    } 
    
    catch (error) {
      return left(GeneralFailure());
    }
  }
}
