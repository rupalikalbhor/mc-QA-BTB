def verify_agree_comment

end

def verify_agree
  id= page.evaluate_script("$('.comment .agreement a:eq(0)').parent().parent().parent().attr('data-comment-id')").to_s
  find(:xpath, "//div[@data-comment-id=#{id}]/div/span/a").click
  visit page.driver.browser.current_url
  find(:xpath, "//div[@data-comment-id=#{id}]/div/span/a").text.should eq('You Agree')
end
