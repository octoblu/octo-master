GatebluContainer = require '../gateblu-container'

describe 'GatebluContainer', ->
  beforeEach ->
    @childProcess =
      stdin: {write: sinon.spy(), end: sinon.spy()}
      stdout: pipe: sinon.spy()
      stderr: pipe: sinon.spy()
    @dependencies = spawn: sinon.stub().returns(@childProcess)

  describe '->start', ->
    describe 'when called', ->
      beforeEach ->
        @sut = new GatebluContainer {}, @dependencies
        @sut.start()

      it 'should call spawn with the kubectl command', ->
        expect(@dependencies.spawn).to.have.been.calledWith "kubectl.sh", ["create", "-f", "-"]

      it 'should call stdin write on the childProcess', ->
        expect(@childProcess.stdin.write).to.have.been.called
