GatebluContainer = require '../gateblu-container'

describe 'GatebluContainer', ->
  beforeEach ->
    @childProcess =
      stdin: {write: sinon.spy(), end: sinon.spy()}
      stdout: pipe: sinon.spy()
      stderr: pipe: sinon.spy()
    @dependencies = spawn: sinon.stub().returns(@childProcess)

  describe '->create', ->
    describe 'when called', ->
      beforeEach ->
        @sut = new GatebluContainer {}, @dependencies
        @sut.create()

      it 'should call spawn with the kubectl command', ->
        expect(@dependencies.spawn).to.have.been.calledWith "kubectl.sh", ["create", "-f", "-"]

      it 'should call stdin write on the childProcess', ->
        expect(@childProcess.stdin.write).to.have.been.called

  describe '->delete', ->
    describe 'when called', ->
      beforeEach ->
        @sut = new GatebluContainer {}, @dependencies
        @sut.delete()

      it 'should call spawn with the kubectl command', ->
        expect(@dependencies.spawn).to.have.been.calledWith "kubectl.sh", ["stop", "-f", "-"]

      it 'should call stdin write on the childProcess', ->
        expect(@childProcess.stdin.write).to.have.been.called
