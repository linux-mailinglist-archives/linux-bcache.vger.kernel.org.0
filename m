Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465012863CD
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Oct 2020 18:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgJGQYQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Oct 2020 12:24:16 -0400
Received: from sonic302-2.consmr.mail.bf2.yahoo.com ([74.6.135.41]:45463 "EHLO
        sonic302-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727665AbgJGQYQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Oct 2020 12:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602087854; bh=PxMwWzXvs+dqOoH0/FHvFmQpYH2JguaCUHYAVLLmaiw=; h=Date:From:Reply-To:Cc:Subject:References:From:Subject; b=RL0MkH6Y32MOGbpBR6fdf5Kwg3xEpnkAqs2TVqWiqzXN04lOV0LBzveBEI1RvwlqWf6jvTts6wEysccsICtZPjIjHxI1Uxs/srgeNiC4EWNgcMfZhssyNKZDXY57VraC4JiFbvrQsp5TxYFOpaKQWNUp4h70tUEeMWhjU2cEHjDBpsemuzGgYA1AOWPXr1Z5TvvgV7KelkUytEp5pSc5cgXdi8pLjSXptVOxjO0loMXKWmANPhnotaG6s8smKNDivXt2srKH0d52O1IiO6a7SZ23gW0s+xJ/iC/fP12mszbtF7HAN6YIOw1y+5Eyb09GLl+ebYuXevJZmhAtxJ9LGQ==
X-YMail-OSG: 3XZ9K0oVM1nEGE.WLlGmyyTvBFkynBGX6vHIMcEil.sf11gLA3mrS7V.uO4ru8n
 A0zLNaMtWdIQK3SGdLSlYYUo.f3fGrOXOKNQEKd73C2Rr8dWWs_SELt52Rc7gLVRdVrTbCDEOMZS
 .M26P_F_1p_r_KD7At0jXh.H0CT76ogrXkAWDP.kmKLLa0IDQy70mg1USMZLNSfRePZLfWYMbkuq
 ACqdpq5Ni_GIylJfZjZkEhKLdbsElSZm4HFYevax3j7.08SE6Bb5HqIlFhN8M9gXF7TPrqzxMUgp
 wJTa1feRqW_36QvNkLIdPM5iZM1MJ8jc1FJphPwlZJjUlZ4tJoOiFCTuLvgENX1omU8OV.5mY3D5
 WBmbmjMsjdVU.aUtJOA2X_3Gewpu3fUnkONMXEmgK.nSOZvx22RUYdS0lycr1zgGaNBzmlM63Zzx
 n4JtkU9jvoQIPMpnjOiALVPkXZ71YQsdHhN32ySDQ.YUWPyZF4kYkDez2CiSqUCAsjMTaf.feYrQ
 LQlmfdSQwM6qONczk9Thd9iQjcE0cB04MjLPFKZrH9lSZKqayd61uKiEYbHehXk.1ln6dbf3F_D4
 jH3WiwVuxJtCcb3wK8L5Htpe5fldqs7eUNZLQdk0slD8lfivz7r4lw.kn7rBfgdbQpQBmvs5Hdbr
 YqSSTTta5Jk5UqdEdstSvYtJo8E.VMlr2ZSW6Twz6HQtTXbinOqHkCVnEe16QDfDatHQCt_MNEfJ
 0zAK3ADLnEiycpVetinTivYRqdJhGTkYcxe0JdgNqNi7D5gFWntS_1.e2AKNJRvtbQkwGQfgVXqU
 ITCIpQxkfRC2UEuFWKbLKSjc9TDD8iYzc8LwKAe9nGciRgTIQA0kQt_EntbtusDPtZya9tthklvs
 xCV.lHxR6gFz6OCsMxA8IkM57sAV2Kv_FE6H80jdswFq9UBYHvabbKd_Lk52Vs7_KoZWfNHQewd0
 pQjpykkutYeYEUoEQWRlq.I9ALjsoA6oXJ9cuCld7OrJXL_IdxZHtADx_EpX0x0q1mGIDOndY1dX
 EdBedaEi2ZjTRf3m83CppRMQd6SvvF7ZaTEW7aWUM6E3.O1ZSkEf4f0aURD.cYibF7Xerxs5UpS.
 dQbB5YnOomJBvsCq95qrP0KMi.1O_fJzzF_TJxIHz2U0EVFJUeMSgEAfl4AON36R6v6_q53J56mz
 PFYrzh8xx6PZyXZBFJvUAIyuwwCnPZHcIY_utuWLKUcu9AIQmZ91Mx9vFloBBic6w9njy3IyZXml
 4d_MkkFbeuXsp.y4D.6gVAVzvMp.LLO0_KhvhrFTAH_QidRgXfuuymMz80QFObprmq2DifWvpEKN
 IHTuWcuoKURFp9lNLP8zMjrl4FpjxjmDaH0hdY3VXM9iJPi2Xo4Jc4KR6rrt6CyZAoUYU8GVn0JG
 9KrgyuD3CqTIH2Q57LjrvFqmoH6KSKzGz.KSmILYU.ZbjOVzAUpadc4I-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Wed, 7 Oct 2020 16:24:14 +0000
Date:   Wed, 7 Oct 2020 16:24:09 +0000 (UTC)
From:   Marilyn Robert <fredodinga22@gmail.com>
Reply-To: marilyobert@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net,
        claudiu.beznea@microchip.com, nick@shmanahar.org,
        simon@thekelleys.org.uk, peterz@infradead.org,
        boqun.feng@gmail.com, linuxdrivers@attotech.com,
        stefan@datenfreihafen.org, paul@paul-moore.com, eparis@redhat.com,
        linux-audit@redhat.com, miguel.ojeda.sandonis@gmail.com,
        ak@it-klinger.de, ralf@linux-mips.org, peda@axentia.se,
        krzysztof.adamski@nokia.com, mchehab@kernel.org,
        b43-dev@lists.infradead.org, larry.finger@lwfinger.net,
        lee.jones@linaro.org, daniel.thompson@linaro.org,
        jingoohan1@gmail.com, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        b.a.t.m.a.n@lists.open-mesh.org, t.sailer@alumni.ethz.ch,
        colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, reksio@newterm.pl, luisbg@kernel.org,
        salah.triki@gmail.com, paolo.valente@linaro.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, aivazian.tigran@gmail.com,
        jansimon.moeller@gmx.de, joern@lazybastard.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, dan@dlrobertson.com,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        kpsingh@chromium.org, bpf@vger.kernel.org,
        illusionist.neo@gmail.com, zlim.lnx@gmail.com,
        paulburton@kernel.org, kuba@kernel.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, luke.r.nels@gmail.com, xi.wang@gmail.com,
        bjorn.topel@gmail.com, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, davem@davemloft.net, udknight@gmail.com,
        michael.chan@broadcom.com, f.fainelli@gmail.com,
        openwrt-devel@lists.openwrt.org, nsaenzjulienne@suse.de,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org
Message-ID: <2122739876.148730.1602087849392@mail.yahoo.com>
Subject: =?UTF-8?B?0J3QsNGY0LzQuNC70LAg0LrQsNGYINCz0L7RgdC/0L7QtNCw0YDQvtGC?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
References: <2122739876.148730.1602087849392.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.125 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

DQoNCtCd0LDRmNC80LjQu9CwINC60LDRmCDQs9C+0YHQv9C+0LTQsNGA0L7Rgg0KDQrQiNCw0YEg
0YHRg9C8IDY4LdCz0L7QtNC40YjQvdCwINC20LXQvdCwLCDQutC+0ZjQsCDRgdGC0YDQsNC00LAg
0L7QtCDQv9GA0L7QtNC+0LvQttC10L0g0LrQsNGA0YbQuNC90L7QvCDQvdCwINC00L7RmNC60LAs
INC+0LQg0YHQuNGC0LUg0LzQtdC00LjRhtC40L3RgdC60Lgg0LjQvdC00LjQutCw0YbQuNC4LCDQ
vNC+0ZjQsNGC0LAg0YHQvtGB0YLQvtGY0LHQsCDQvdCw0LLQuNGB0YLQuNC90LAg0YHQtSDQstC7
0L7RiNC4INC4INC+0YfQuNCz0LvQtdC00L3QviDQtSDQtNC10LrQsCDQvNC+0LbQtdCx0Lgg0L3Q
tdC80LAg0LTQsCDQttC40LLQtdCw0Lwg0L/QvtCy0LXRnNC1INC+0LQg0YjQtdGB0YIg0LzQtdGB
0LXRhtC4INC60LDQutC+INGA0LXQt9GD0LvRgtCw0YIg0L3QsCDQsdGA0LfQuNC+0YIg0YDQsNGB
0YIg0Lgg0LHQvtC70LrQsNGC0LAg0YjRgtC+INGB0LUg0ZjQsNCy0YPQstCwINC60LDRmCDQvdC1
0LAuINCc0L7RmNC+0YIg0YHQvtC/0YDRg9CzINC/0L7Rh9C40L3QsCDQvdC10LrQvtC70LrRgyDQ
s9C+0LTQuNC90Lgg0L3QsNC90LDQt9Cw0LQg0Lgg0L3QsNGI0LjRgtC1INC00L7Qu9Cz0Lgg0LPQ
vtC00LjQvdC4INCx0YDQsNC6INC90LUg0LHQtdCwINCx0LvQsNCz0L7RgdC70L7QstC10L3QuCDR
gdC+INC90LjRgtGDINC10LTQvdC+INC00LXRgtC1LCDQv9C+INC90LXQs9C+0LLQsNGC0LAg0YHQ
vNGA0YIg0LPQviDQvdCw0YHQu9C10LTQuNCyINGG0LXQu9C+0YLQviDQvdC10LPQvtCy0L4g0LHQ
vtCz0LDRgtGB0YLQstC+Lg0KDQrQlNC+0LDRk9Cw0Lwg0LrQsNGYINCy0LDRgSDQvtGC0LrQsNC6
0L4g0YHQtSDQv9C+0LzQvtC70LjQsiDQt9CwINGC0L7QsCwg0L/QvtC00LPQvtGC0LLQtdC9INGB
0YPQvCDQtNCwINC00L7QvdC40YDQsNC8INGB0YPQvNCwINC+0LQgMiwgMzAwLCAwMDAg0LXQstGA
0LAg0LfQsCDQv9C+0LzQvtGIINC90LAg0YHQuNGA0L7QvNCw0YjQvdC40YLQtSwg0YHQuNGA0L7Q
vNCw0YjQvdC40YLQtSDQuCDQv9C+0LzQsNC70LrRgyDQv9GA0LjQstC40LvQtdCz0LjRgNCw0L3Q
uNGC0LUg0LzQtdGT0YMg0LLQsNGI0LjRgtC1INGB0L7QsdGA0LDQvdC40ZjQsCAvINC+0L/RiNGC
0LXRgdGC0LLQvi4g0JfQsNCx0LXQu9C10LbQtdGC0LUg0LTQtdC60LAg0L7QstC+0Zgg0YTQvtC9
0LQg0LUg0LTQtdC/0L7QvdC40YDQsNC9INCy0L4g0LHQsNC90LrQsCDQutCw0LTQtSDRiNGC0L4g
0YDQsNCx0L7RgtC10YjQtSDQvNC+0ZjQvtGCINGB0L7Qv9GA0YPQsy4gQXBwcmVjaWF0ZdC1INGG
0LXQvdCw0Lwg0LDQutC+INC+0LHRgNC90LXRgtC1INCy0L3QuNC80LDQvdC40LUg0L3QsCDQvNC+
0LXRgtC+INCx0LDRgNCw0ZrQtSDQt9CwINC/0YDQvtC/0LDQs9C40YDQsNGa0LUg0L3QsCDQvNCw
0YHQsNC20LDRgtCwINC90LAg0LrRgNCw0LvRgdGC0LLQvtGC0L4sINGc0LUg0LLQuCDQtNCw0LTQ
sNC8INC/0L7QstC10ZzQtSDQtNC10YLQsNC70Lgg0LfQsCDRgtC+0LAg0LrQsNC60L4g0LTQsCDQ
v9C+0YHRgtCw0L/QuNGC0LUuDQoNCtCR0LvQsNCz0L7QtNCw0YDQsNC8DQrQky3Rk9CwINCc0LXR
gNC40LvQuNC9INCg0L7QsdC10YDRgg==
