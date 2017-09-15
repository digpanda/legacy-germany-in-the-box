module Helpers
  module Kuaidi
    def kuaidi_wrong_response
      BaseService.new.return_with(:error, 'Fake error')
    end

    def kuaidi_valid_response
      BaseService.new.return_with(:success, current_status: { success: 'ok' },
      current_state: :signature_received,
      current_history:
      [{ 'time' => '2017-09-04 22:57:00', 'context' => '[雅安市]投递并签收，签收人：单位收发章 *', 'location' => '' },
      { 'time' => '2017-09-04 19:51:14', 'context' => '雅安市邮政局现业局投递安排投递（投递员姓名：李虎;联系电话：）', 'location' => '' },
      { 'time' => '2017-09-04 12:06:46', 'context' => '雅安市邮政局现业局投递安排投递（投递员姓名：李虎;联系电话：）', 'location' => '' },
      { 'time' => '2017-09-03 19:41:00', 'context' => '到达 雅安市邮政局邮件处理分局 处理中心', 'location' => '' },
      { 'time' => '2017-09-03 16:50:00', 'context' => '离开成都市 发往雅安市（经转）', 'location' => '' },
      { 'time' => '2017-09-03 09:24:01', 'context' => '离开成都市 发往下一城市（经转）', 'location' => '' },
      { 'time' => '2017-09-02 21:54:35', 'context' => '[成都市]到达成都处理中心处理中心（经转）', 'location' => '' },
      { 'time' => '2017-09-01 15:12:00', 'context' => '[福州市]已离开福州航站，发往成都处理中心', 'location' => '' },
      { 'time' => '2017-09-01 10:08:00', 'context' => '[福州市]到达福州航站', 'location' => '' },
      { 'time' => '2017-09-01 06:08:00', 'context' => '[福州市]离开福州处理中心 发往福州航站', 'location' => '' },
      { 'time' => '2017-08-31 23:02:40', 'context' => '[福州市]到达 福州处理中心 处理中心', 'location' => '' },
      { 'time' => '2017-08-31 21:21:00', 'context' => '已离开福州航站，发往福州市邮件处理中心', 'location' => '' },
      { 'time' => '2017-08-31 21:03:00', 'context' => '[福州市]到达 福州航站 处理中心', 'location' => '' },
      { 'time' => '2017-08-31 14:53:45', 'context' => '福州市邮政速递物流分公司大客户部已收件（揽投员姓名：曾旺,联系电话:13685042529）', 'location' => '' },
      { 'time' => '2017-08-30 15:00:00', 'context' => 'The parcel has been arranged customs clearance.', 'location' => '' },
      { 'time' => '2017-08-27 06:45:00', 'context' => 'The parcel has arrived in the country of destination (China) and is now awaiting customs clearance.', 'location' => '' },
      { 'time' => '2017-08-26 15:10:00',
        'context' => 'The plane has taken off, and the flight number is NN4205/NN837 .The estimated arrival time is 2017/8/27 6:45:00( in Germany ).',
        'location' => '' },
        { 'time' => '2017-08-25 17:00:00', 'context' => 'Shipment is pre-alerted and arranged to send to airport(in Germany).', 'location' => '' },
        { 'time' => '2017-08-24 17:16:28', 'context' => 'The parcel has been packed for shipment.', 'location' => '' },
        { 'time' => '2017-08-24 11:00:00', 'context' => 'Shipment is pre-alerted.', 'location' => '' },
        { 'time' => '2017-08-22 12:53:38', 'context' => 'Item is announced / PostElbe received the information.', 'location' => '' } ])
    end
  end
end
