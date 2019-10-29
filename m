Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78376E8B7A
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Oct 2019 16:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389843AbfJ2PJG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Oct 2019 11:09:06 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45423 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389387AbfJ2PJG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Oct 2019 11:09:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id y24so7754454plr.12;
        Tue, 29 Oct 2019 08:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6yq6MQrhof3ESKyz3OnyGTPO1G7eC+XyUzxT4zpDdA=;
        b=SGO4sJ6F3UTyYzazYC9NuM7yPCJs6s0sWM9laP9+SiSm7Byx1y+rYMfOKn3GQElEZ5
         N0XNRQZY3LeigvrLRN6dv8fDiBLURcyKrjSbh5wJgpvAIyIa7JchZUUXx10dhJQbGdY9
         xHSFprk4/HHF1tn2FhRSwld0t6LHAp7X2hGiSQgx+cy1D0wbQa1JFloxca22Qi5Em33E
         PkjKBdtw/Qz2Y61Zh00i2LGj4EkUCkIbYSWhpIAQjKogbsxSJISkzhHtTGUG3xR0AA7J
         URGpN7E8nlRUbzMgFKWkkVL73Js/kCCLZSTmlBrjZQR6sN7Ln2Fa+5rqPTG2tcinNc7z
         cGaQ==
X-Gm-Message-State: APjAAAWF4JAszRipw6EUuMujYuEfCsHMVfQSMsJtOjSIZUMnC0JH8dSM
        R17G9ZZEO6IOQL+TYqcVX+JVllA98gs=
X-Google-Smtp-Source: APXvYqxSVksMTeDjdpB8YzBm6Fzs3VMGSiTF0FxBXvv/1VAVrgZlW2rEeQ64xpfFyjgkPQXzGE5bwA==
X-Received: by 2002:a17:902:9347:: with SMTP id g7mr4620830plp.291.1572361745028;
        Tue, 29 Oct 2019 08:09:05 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w26sm11345982pfj.123.2019.10.29.08.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 08:09:03 -0700 (PDT)
Subject: Re: [PATCH V3] block: optimize for small block size IO
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
References: <20191029105125.12928-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <41c9df3e-ee79-849e-96d6-6a6b404ec23d@acm.org>
Date:   Tue, 29 Oct 2019 08:09:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029105125.12928-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/29/19 3:51 AM, Ming Lei wrote:
> __blk_queue_split() may be a bit heavy for small block size(such as
> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> multiple page. And only consider to try splitting this bio in case
> that the multiple page flag is set.
> 
> ~3% - 5% IOPS improvement can be observed on io_uring test over
> null_blk(MQ), and the io_uring test code is from fio/t/io_uring.c
> 
> bch_bio_map() should be the only one which doesn't use bio_add_page(),
> so force to mark bio built via bch_bio_map() as MULTI_PAGE.
> 
> RAID5 has similar usage too, however the bio is really single-page bio,
> so not necessary to handle it.

Although this patch looks fine to me, I'm concerned about the new flag. 
That's additional state information and something that could get out of 
sync. Has it been considered to implement this optimization by handling
bio->bi_vcnt == 1 separately at the start of blk_bio_segment_split()?

Thanks,

Bart.
