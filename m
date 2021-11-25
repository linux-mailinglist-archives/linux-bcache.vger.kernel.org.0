Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA14D45E1F1
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Nov 2021 22:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhKYVOg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Nov 2021 16:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhKYVMf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Nov 2021 16:12:35 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EADC06175B
        for <linux-bcache@vger.kernel.org>; Thu, 25 Nov 2021 13:07:31 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id y16so8983114ioc.8
        for <linux-bcache@vger.kernel.org>; Thu, 25 Nov 2021 13:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ptUvXWnHFTEjd8NLf2/MtTjEjiATPRukf4apEyvnHzs=;
        b=Ok1P9w2zeGVzIESIN4pPNTb2gePDrh7PkYcZc61pXluqLnkbyJtwbpgeFvFvsUDFaY
         3RcmLQvTLVR75p+AnQUD+cZ2DErpBjnestkr5fCc2JHJNnfiGaihVrD9TeYhiApsqzOK
         /mOsM9N9SXmWgcLZuEFKuynZJHKkMOfkSW/5ryenYLoCn6I3424ObrgiSY9YzwbSFfRO
         kmmrGcTllfpSj5RhWT7YjPm5HDm4cToQPO20haFOfaYHC9XSn1rLb9hyO1es1fZO2ZzC
         VjZ+sIM0dRXq/RWRiqaBSfaFruCQLjV19xv+RRd0wshHosLmai6Bwbpf11nfPPekqXZz
         dx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ptUvXWnHFTEjd8NLf2/MtTjEjiATPRukf4apEyvnHzs=;
        b=CyosE84obkfYD94aJ6RLJZf1C8S368yXY6pobUGlqAdT73g/uzxNcifBaknh+JaW2v
         Q3LpISmPbj5scHFY914TmD/6E90cHTzQKTkfV7eF6ob7LNCQH6h3pXqRylpyz6vC2Jgj
         rzsqx47Lfp/PfJjVivWtKH/0E3rceqZJRUj6bJhLpMtK1PA5Y6rmI7dPjXoZo8PRtUeG
         szB7+K6PJaZReCDTINes1YGinvzdoqqUQmIETsPnGOYqQVwMSphEFmvOruzMRrw7Dzxn
         pqA6PuqcXNDtuldFoxnSoXJ3+UlU4uv9nP/ZhHbxckRMCaJ3YzdjbpMyl/5cIW3VRtJl
         uC5g==
X-Gm-Message-State: AOAM533w9PnNqtcgJwoAVmakb6VKn19VHRj0Zjmnv5xMqBh8Zr0/JWmz
        tizdNv+vzoSAoJi+dmpQFdN4/w==
X-Google-Smtp-Source: ABdhPJytq9NfIBEXIegOGelrfmrArxCP5Vbnt6AUGHXX+T5C6V1sUA6iD/NmIKlHSz8tfc+R5WgM8w==
X-Received: by 2002:a5d:9ec2:: with SMTP id a2mr30507116ioe.44.1637874451048;
        Thu, 25 Nov 2021 13:07:31 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m5sm2088428iln.11.2021.11.25.13.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 13:07:30 -0800 (PST)
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
To:     "Kenneth R. Crudup" <kenny@panix.com>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com>
 <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk>
 <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <17206ea6-506d-b1de-09e8-c935ff308bd6@kernel.dk>
Date:   Thu, 25 Nov 2021 14:07:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/25/21 2:05 PM, Kenneth R. Crudup wrote:
> 
> On Tue, 23 Nov 2021, Jens Axboe wrote:
> 
>> It looks like some missed accounting. You can just disable wbt for now, would
>> be a useful data point to see if that fixes it. Just do:
> 
>> echo 0 > /sys/block/nvme0n1/queue/wbt_lat_usec
> 
>> and that will disable writeback throttling on that device.
> 
> It's been about 48 hours and haven't seen the issue since doing this.

Great, thanks for verifying. From your report 5.16-rc2 has the issue, is
5.15 fine?

-- 
Jens Axboe

