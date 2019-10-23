Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61800E1597
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Oct 2019 11:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390436AbfJWJSL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Oct 2019 05:18:11 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:39588 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390380AbfJWJSL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Oct 2019 05:18:11 -0400
Received: by mail-lj1-f174.google.com with SMTP id y3so20277348ljj.6
        for <linux-bcache@vger.kernel.org>; Wed, 23 Oct 2019 02:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kqsOJccsya9qoOSyYNz60KgSDbq3Swl9s6NOgUDboP0=;
        b=jMo0RxwxqnzHTmS7ZEcYpF68qkcNqgkprLsap0AS+48z0QBtYL69HYvjvUl2o5P513
         EVC6YdkUiBsjwMnbz0BcLmaKsfGorAHfkCyR64+WyfYvLrPxH+K3zaOcliE/rnJy1uCc
         KP/p5KFiZq1Sj9PEORhSNBkqyTTZqPFpSVuWRjnhjvWkULy1h2JyrWYKzBcB5o1C5Ie4
         wvWh8DvAXCkq6K9niUmdE4ALuhoEG8PmrjHMkI7K6R//wCuyBpMxeHebIUhk81b0kF1B
         wGlh9T9IoRJzkVu2W5ECkxIqlJpDdACEqehH8SaFUXOWZdTKIcPbyXv1C5IdGEwK89yz
         oGMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kqsOJccsya9qoOSyYNz60KgSDbq3Swl9s6NOgUDboP0=;
        b=Ljmu9G6B9n0rcVSLm5NAjQfpQX8sGlClBW2Y4F+mMkQBulNqz2UQcpBL6fdA1a0D7n
         jLGRn085i92a9En3QW/TqHLHuogheoGWTe+svmkn81Hf9vStuUnAdiM+V3NbPFXFDwMf
         E1Z15F9XoC9NQ9vkTdy69r5SpxkGVg1y8BiOkvCiTxZNgVLLuYLgrkAOY6C9YjqFF5GA
         BDWeDek9wr0/JlFIAYGzwCCu8C0+6g6pBHOC4GqqlqeRQXwv/ErVVdA9YE3O6gEfTgam
         tLSVNihj0TCMCMIkX7PA+AfpMskQTwnyld+tB3mVJOoq9F1gylw5KEyUf/EPIUiYDQLv
         P6XQ==
X-Gm-Message-State: APjAAAU2EZl83pnM2v0fuSbLeUknQG+wUoKTqBwDStj77IQucNLf+fL5
        PIbZNW4/jlN3XRASNmmFcab7v6TQOykuVgbKfLA=
X-Google-Smtp-Source: APXvYqxNu4KMKWf0Z80TtIuxmFit32ld5G80e9JMB53MVtmvZh1yS+eCRyr3GpBZ/DUUIOwfXqPcnrfNXC0qgUA1GY4=
X-Received: by 2002:a2e:3919:: with SMTP id g25mr21762427lja.242.1571822289073;
 Wed, 23 Oct 2019 02:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAExpLJg86wKgY=1iPt6VMOiWbVKHU-TCQqWa0aD1OA-ype07sw@mail.gmail.com>
 <18e5a2af-da70-60f6-6bd9-33f585b5971b@suse.de> <alpine.LRH.2.11.1910221906210.25870@mx.ewheeler.net>
 <11f217a7-2ea8-65c5-6317-a4f2b56aa200@suse.de>
In-Reply-To: <11f217a7-2ea8-65c5-6317-a4f2b56aa200@suse.de>
From:   Sergey Kolesnikov <rockingdemon@gmail.com>
Date:   Wed, 23 Oct 2019 12:17:57 +0300
Message-ID: <CAExpLJhXrsuVm5G8P-G7zPCnheZTMe__Aqa9RKDWj3cjGPB99w@mail.gmail.com>
Subject: Re: Getting high cache_bypass_misses in my setup
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

=D1=81=D1=80, 23 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 11:20, Coly Li <co=
lyli@suse.de>:
>
> On 2019/10/23 3:12 =E4=B8=8A=E5=8D=88, Eric Wheeler wrote:

> > On Tue, 15 Oct 2019, Coly Li wrote:
> >> I have no much idea. The 4Kn SSD is totally new to me. Last time I saw
> >> Eric Wheeler reported 4Kn hard diver didn't work well as backing devic=
e,
> >> and I don't find an exact reason up to now. I am not able to say 4Kn i=
s
> >> not supported or not, before I have such device to test...

Coly, thank you for your reply. It seems I'll have ot do some more
tests and dive a little into bcache sources when I have time.
Meanwhile, could you please explain what cache_bypass_misses and
cache_bypass_hits mean? It's not obvious from the docs.


> Yes, this is the problem I wanted to say. Kent suggested me to look into
> the extent code, but I didn't find anything suspicious. Also I tried to
> buy a 4Kn SSD, but it seemed not for consumer market and I could not
> find it from Taobao (www.taobao.com).

I'm using SANDISK Extreme Pro SDSSDXPM2-500G-G25 M.2 NVMe drive and
it's quite common desktop drive, just use native 4K format (nvme-cli)
LBA Format  0 : Metadata Size: 0   bytes - Data Size: 512 bytes -
Relative Performance: 0x2 Good
LBA Format  1 : Metadata Size: 0   bytes - Data Size: 4096 bytes -
Relative Performance: 0x1 Better (in use)

I'm not sure, but I think other drives support this too.

----
Best regards,
Sergey.
