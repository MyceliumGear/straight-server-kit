shared_context 'resources' do
  let(:client) { StraightServerKit::Client.new(url: 'http://gear.loc') }
  let(:connection) { client.connection }
  let(:gateway_id) { 'c2809c9fd3465529d2946fb8299450b4f46b24fc40f0e3a641e7e19cd75a3adb' }
  let(:gateway_secret) { 'w4b1lc5qs3n0vx9q8q76yxparfcmto1dqlr6vo5hh7mfvaoz64epa4e7qhvmv4vg' }
end
