Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0A41B92BB
	for <lists+linux-bcache@lfdr.de>; Sun, 26 Apr 2020 20:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgDZSQu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 26 Apr 2020 14:16:50 -0400
Received: from mout.web.de ([212.227.17.11]:57983 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgDZSQu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 26 Apr 2020 14:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587924998;
        bh=Kq9tVciP0aoxOXS+OnnJQPq33LIU0ZN36h026g/j1PY=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=hH9RDEa8AQt3Fk/GxfPyy/qijzpnLlLjd8Fsn/8Rrb/rIfu1auSIJi8HqMqGWia0k
         S0RlCXOyB+DWt1U2QWJMUWlx1n2Rh8Pu84AX4qrTi3MkXvN849p1VmovyMOfITW1Vj
         sSNvd/+L5Qv5JDzSoBIhikfCk6Z2+fz8sOA92dmA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.52.156]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MCImL-1jJjQC3md7-0099y3; Sun, 26
 Apr 2020 20:16:38 +0200
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        linux-bcache@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Coly Li <colyli@suse.de>, Feilong Lin <linfeilong@huawei.com>,
        Kent Overstreet <kmo@daterainc.com>, mingfangsen@huawei.com,
        renxudong1@huawei.com, Wu Bo <wubo40@huawei.com>,
        yanxiaodan@huawei.com
Subject: Re: [PATCH V2] bcache: fix potential deadlock problem in
 btree_gc_coalesce
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <80c2a2c6-01b9-8280-34b4-ff6b9cfaf76a@web.de>
Date:   Sun, 26 Apr 2020 20:16:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:E1jSvYhkSSKJu76IhuLc8ALiSJ1F719BmZP0UehV5f9w/ElUxaK
 rT70czBqUY4t/tb74avmPSinHTA/MJ3PmZFuwUgk1rfabew1/ZwSgTjQiwr4YVOWXFlXOSB
 klsr0Ln2Jn7sfDVXrXR/qvqCOkxeyrOHRL6HLWMVh26A/IGnvxGljwYtwfjiFoHyuyXKAdW
 A1F35H/Agx1n+DiQEntVg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:G0Yr6DPWQXM=:YhHmIbKn+z477LCeQq5gRt
 kikgUz2sWKJB4cCzAp4oUM7sK5zrdpUJcqqyxWi00vd+mKuiUhP+KZfo95aaKoseKJmsJtngI
 1+eXw2xr6TFPnkxGg7tSeUvi+fIn5SUJ9jryXjDwlKxx1c85fVh+g9oWCWlBSeeAVZRelT3uk
 WQoVHDT3wZp0yLZxc1UodJiokSP2/jY7Df+odVw5fshslDqGFJe6yH+1WXaAMF2y1mWOfEh4X
 gtEV2MkHxfkR90citcOjVf8b3Y+Qf764NNFll+4AaQXY3BzE8vvYBkgUFwB1E4mtQYcABmcSf
 dKNCh4DIAm3LJ38e548wm4rZajDhGB9MzpzWdVUARiYw4pg4VFvF+aEAhY1bxD+xP80hjPlfK
 jlyN/r6ZuVqjKh5mLI4zVw1Wb45ySdIUhzN6oTzlrAqGdUjygb4S9AKRWe7I+WxFq7Us3H38J
 i/BF5i4BYmNOKGPjFIDsnXrKZ27uzO1kBnZf+iqDwSsXDTQsGSpvOvYHEQLhM0hZ9xSADD2iT
 W04Zn8DOI7c5l3/602tqCpe3Rn/repGkkGuTdwtEZ7GfPZAZOFNluHCVemdv/7Y6k89sDETA1
 ToXoDuAjVXl3GuRufgtoUqC2TQxx7PsCepFMt/GNsh6REHINXdyM/kWOuAebgxCz+w+VNjgof
 KWbE/PNy1IEnFM7+kpON1alWx9gz3Tv2rKjzP0J6D7b99nqfB5oh05LL5sUhABERuoRJYsls8
 rFxujhPTwVAbeO9kOz4L8c5U8zDABQ9FhZ5l1yDjkShUi1lH1Qamm56HvIFAbO0KXIosMy2wN
 GHSoIL8zDOBzivcS3N+pPGJIwN9cx1VsyScKVFxBG8VChjPkp0M4giLEETFwayA0zEvQ3bQDk
 a68ZbdQgwWzkp4HcoWGwWCZ8t5svR+CE10QhOJI0x8ebemP3Yx1ftsNglPtrad3c2l0EEu+vQ
 OsaM6xGNNV6PGe7fE7uo1SRTy1jUJK7X0Oqn9CXAw8RA6+KSAJNvIeYC6fWQY4a2t6U+dqDIZ
 vTuoTjanWoy8/6+q4YSqyR3ssAsWZb75yLNTyJ2tVCyYmINK+bJbfs9ECa0p2WjsRxtmWprgv
 AHUpq9/JzirU4G8CzXtALUwm2HwhZebrS///WxnCs1QzRsYrbUSAQxcs2GzOpcAs9l2g08Kcr
 bgP/vMWAFvbRjfsDifzQPz6y4asdctAfhbQzFiveIm54ZTxgD9ZejAMN3Z5XocREcPT2s1aC0
 MJbSlGerztGNE+3h0
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> --
> V1->V2: rewrite commit log (suggested by Coly Li) and rename the patch

* The patch version description should be placed behind triple dashes.

* I would find a shorter version identification (without the arrow)
  also sufficient.


> Fixes: 2a285686c1 ("bcache: btree locking rework")>

Will a longer commit identifier be safer for the final change description?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=b2768df24ec400dd4f7fa79542f797e904812053#n183

Regards,
Markus
