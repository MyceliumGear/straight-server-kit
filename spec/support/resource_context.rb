shared_context 'resources' do
  let(:gateway_id) { '73da14f2677eab39fa6e18076f777fde6af5a3f126062419160152b1a2f3ec60' }
  let(:gateway_secret) { '2JmB6DGD59TjYMREYkp3MR8peW5KLx1Zb8sRASjHP5JabPyMeJo985CJdKCeSgvA' }
  let(:client) { StraightServerKit::Client.new(gateway_id: gateway_id, secret: gateway_secret) }
end
