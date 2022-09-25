Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD9E5E934E
	for <lists+linux-bcache@lfdr.de>; Sun, 25 Sep 2022 15:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiIYNOo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 25 Sep 2022 09:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIYNOl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 25 Sep 2022 09:14:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8BC63B4
        for <linux-bcache@vger.kernel.org>; Sun, 25 Sep 2022 06:14:38 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dv25so9069768ejb.12
        for <linux-bcache@vger.kernel.org>; Sun, 25 Sep 2022 06:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=jpMxiK+GKL+bU55mcNt2khoci6Q6RoHMb8KN6+Qs4N0=;
        b=Oy6zvocXwntNrmm1+F7RxN3Bc/KmZmo6k/fMVJGYSq3eRvoZhqFjK/9DB22QwGZCoz
         qCZviL0SkCHqlshoGgL5vVf+pYNbgMinQV/OUX3cfZWlnvaSY2qUJIBVSfWSaawS+L56
         1ENyiOY4+jqWe9zTk5iZ750DKrsx/5Xn8WG9vsqEGDOoFlcHrXb4EjzUbIiPP7kGMI0Q
         mZ/I/+fmF8zu0t1hIN7i/ygnslAFbNBSUwpGTbQY0Tavw3z6g1adwiJ3wXHVl7Qvhoa3
         PcOKd/WfGDOVu6hhmMmUi3i/Ly5FNzjCNqskgoMhtQPNMBfAWlFkTBWaVW+GMcQkwv1n
         4AJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=jpMxiK+GKL+bU55mcNt2khoci6Q6RoHMb8KN6+Qs4N0=;
        b=GChGHJziasRzTDqOhUgAfr8Re6D36/8ow+o2c9+Sd041QDOQW5FFvO/P/ND5AXJBNg
         P4rYwQ3pGw7uhDjssYflj9XXEw78QM/CKKcguxo55VR2fBg0STirb/hOyT52eC2OAc4r
         dQSUDHYkugVisuWjleoR0GUdRfuabDD1FseCojbgzPMSaZcvhXo+aqMSe7vUccuIwPK1
         8NJ1UoXqayv+0TkEuFBhK3tN66ichNKFRiz0DrfiW9aFp+ntgsZ93+c8dtgkZgUNDWD7
         8ueqHZ+TH3le06iGjf5VRKQz26yHtSpV/6Gmm8iDB85HeLGsfD8O0KXuBNsI4D+GMj8W
         CtkQ==
X-Gm-Message-State: ACrzQf3Mho2/HSjyRY/uZ5JyvyTu5vB8sJNgBnFJ2P7PjZEDrxM87h72
        LZlkAiXW7ilEFtuk8Rwa7ffKiBbLVeKSiRT9
X-Google-Smtp-Source: AMsMyM5FacOw3fncGkGS0FnWtvbZbbBK5T/OtHEqZHs5feD5eCFdHKIo1Wn0d+2vIcRSgb8M2kcNsA==
X-Received: by 2002:a17:907:75e2:b0:77b:4445:a850 with SMTP id jz2-20020a17090775e200b0077b4445a850mr14202479ejc.587.1664111676610;
        Sun, 25 Sep 2022 06:14:36 -0700 (PDT)
Received: from [192.168.254.7] (94-212-137-119.cable.dynamic.v4.ziggo.nl. [94.212.137.119])
        by smtp.gmail.com with ESMTPSA id b12-20020a170906d10c00b0076f99055520sm6790667ejz.137.2022.09.25.06.14.35
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Sep 2022 06:14:35 -0700 (PDT)
Message-ID: <68fe0b49-13ed-0565-0558-46ba0edd9a40@rolffokkens.nl>
Date:   Sun, 25 Sep 2022 15:14:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
To:     linux-bcache@vger.kernel.org
Content-Language: en-US
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Subject: About to orphan bcache-tools for Fedora
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all,

In 2013 I took it upon me to include and integrate bcache-tools in 
Fedora, which required tweaks in lvm2, util-linux and other packages. 
With the help of the respective maintainers, it all got into good shape 
in Fedora 21.

I have been using it myself ever since, but have been struggling 
somewhat with my bcache on raid5 setup recent years. Not sure if the 
combination was the cause of random filesystem corruptions, or other 
hardware issues. For sure this PC had some PSU issues causing one of the 
HDD's to frequently reset. But after replacing the PSU about a year ago 
all HDD's have been rock steady. Ever since no usefull error messages 
ever popped up, but these random filesystem corruptions have stayed. And 
to be specific: only when using writeback caching, and mostly when doing 
heavy writes. No useful data however to file a proper bug report.

Not being able to identify the cause, a month ago I decided to replace 
bcache with lvm-cache (lvm-cache was no viable alternative in 2013). 
Just to see if that solved the issue, or provided clues about the cause 
of the issue. Not as easy to use as bcache (had to use LVM stacking to 
use lvm-cache in my setup) but in the end it all works. And the 
filesystem corruptions seem to be a thing of the past now. I decided to 
cowardly walk away from the issues I've had for a while, I'm just too 
happy it's stable now. This means that I won't be using bache anymore on 
my daily driver.

Now on the other side, I also have a Dell Inspiron 5570 from 2017 laptop 
that's using bcache and it has been running fine ever since. Different 
hardware, simpler setup: no raid, just a ssd and a sata hdd. As long as 
this laptop is alive I'm able to provide some form of support to Fedora 
users, but after that.... any new laptop will just be plain SSD.

So I'm about to orphan bcache-tools for Fedora, meaning there will be no 
maintainer. Before doing so I'm bringing it up here, maybe here's 
somebody willing to adopt the Fedora package...

Cheers,

Rolf

