Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB5018ED9
	for <lists+linux-bcache@lfdr.de>; Thu,  9 May 2019 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfEIRVg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 9 May 2019 13:21:36 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41185 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfEIRVg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 May 2019 13:21:36 -0400
Received: by mail-ed1-f66.google.com with SMTP id m4so2718478edd.8
        for <linux-bcache@vger.kernel.org>; Thu, 09 May 2019 10:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=mhj2IiOK5/1PSX4gv+vp9KU1onQsmoJsGeE6J1/uXuo=;
        b=oejhAJc/NLdVNmSkuvl8x6dmywczBX7ruGGcUtW7EACSZN+Z/u9p2+TL1u4QeDIzJQ
         9R3u4YlhyINTDFoz+zc5bU1rsuXw1Py7tNP73l/ft8PuLJaR6SsOOQ5Tc/ktZaItnlTD
         C0OE/Mx/J4Jsz7Kf5yHxIaPSCj5J84IK8fKmMPvlyq3CnuMKikv+KDJToIAnkepofusR
         5t7vLq/W0eeFa8aW6InUqyPTB7CsG+MeNi57+EOVMnMEHYEqguGzJ9kU8SEIdYvZBngO
         tunqsYbX4ZzJVXKTWJk5vBuNHD3V2y2tZuhYsD6u5FU+GJLUsu8EnFL1ToVL0nEUk5cd
         9psA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mhj2IiOK5/1PSX4gv+vp9KU1onQsmoJsGeE6J1/uXuo=;
        b=WIitKy9LPg3r2ZM+seZIfPAPgY4e9NZTh4XHueHTCDP6SzppC88uUOOYFT07PzdFJ/
         W+Nc4FU7AIO0mCRAxlR8hxhxgfu45/wTV6qp1Ks8B2f+gYKF3Jx1JaMEwmhmF4laRJQm
         01/Rm/BmLCwYhKOo0Gvg6EihC0tmTHTdmbN0Cioea0CvdebXmZx/eUBH9TCgDSCkUnyh
         aGF9nBqmCgKg3Omy9FKaxjT5nASLI+h22HheHS7JiWNn1BKPN919W5HNhPOpdPyofb7a
         coooIFENe8l8OMqD1Al9ndWV+JZaSxMm2Kur8rFi6BbTquuZHh60fzPcWShb/4tV2QCu
         PKng==
X-Gm-Message-State: APjAAAV+3tuQNdwvuPiyhWaDSa3+0qPXxf+MDfWGpwytESL28ZeUpmbS
        OXlW4V/Ass91oP1F2Hu4E4JCyzSDngo=
X-Google-Smtp-Source: APXvYqzw0jOZBllhsEfgH+0wlKJY1eTqkB3DZAlM0wTusfgrWcZwuO5IVbjTQJuJt53PK8N6NR7ysA==
X-Received: by 2002:a17:906:6d99:: with SMTP id h25mr4439604ejt.187.1557422494498;
        Thu, 09 May 2019 10:21:34 -0700 (PDT)
Received: from home07.rolf-en-monique.lan ([89.188.16.145])
        by smtp.gmail.com with ESMTPSA id e21sm396981ejd.15.2019.05.09.10.21.33
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 10:21:33 -0700 (PDT)
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: bcache & Fedora 30: massive corruption
To:     linux-bcache@vger.kernel.org
References: <dfa0b47d-a1c6-3faa-b377-48677502a794@rolffokkens.nl>
Message-ID: <6d386198-49d0-495e-a8d1-1bc7d0191bee@rolffokkens.nl>
Date:   Thu, 9 May 2019 19:21:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <dfa0b47d-a1c6-3faa-b377-48677502a794@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: nl-NL
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

The reproducability is 100%. It's enough to only upgrade to a Fedora 30 
kernel on a Fedora 29 system. The next reboot will probably be the last 
reboot ever.

My Fedora bug report is here:

If it's gcc9 related, the cause may be somewhere between "Fedora's 
decision to use gcc9" and "bcache needing a fix".

Rolf

On 5/6/19 7:45 PM, Rolf Fokkens wrote:
>
> Hi,
>
> I helped in 2013 to get bcache-tools integrated in Fedora 21 
> (https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/thread/UEGAUSP377TB3KMUO7XK42KREHOUDZPG/).
>
> Ever since it worked like a charm, and bcache laptops (we have several 
> at work) survived upgrading to a next Fedora release flawlessly. Since 
> Fedora 30 this has changed however: laptops using bcache mess up 
> backing store big time. It seems as if the backing device is corrupted 
> by random writes all over the place. It's hard to narrow down the 
> cause of this issue, and I'm still in the process of trial and error. 
> May be later on I'll have more info.
>
> Some info:
>
>   * The laptops are using writeback caching
>   * The laptops have a bcache'd root file system
>   * It seems like the issue is in the Fedora kernel 5.0.10 for Fedora
>     30, but not kernel 5.0.10 for Fedora 29.
>   * One notable difference between the Fedora 29 and Fedora 30 kernels
>     is that Fedora 30 uses gcc 9 to build the kernel.
>
> As mentioned i'm still in the process of narrowing down the cause of 
> the issue. But any suggestions are welcome.
>
> Rolf
>

