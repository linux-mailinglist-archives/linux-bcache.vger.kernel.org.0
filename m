Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA38EF416
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 04:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbfKEDdj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 22:33:39 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45366 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728910AbfKEDdj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 22:33:39 -0500
Received: by mail-pg1-f194.google.com with SMTP id w11so2667371pga.12
        for <linux-bcache@vger.kernel.org>; Mon, 04 Nov 2019 19:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tlOex+gWQYpxiWEeGdiftgedeC2MlUqgIjmdPHTDpf0=;
        b=H+doWd0WkLNu+BAH1vaVd+0Fsd2zJwxeBtPr+39yxhFdR1sLPRgZKpvy18csTXKhkM
         qNmtHn9mzma/GA5hHBGXaVF/OAO08h3OPqKM67DGnGlUbv2c677ltX5obAUhYyeYbUXw
         jAAa2ZsYJOvrI5yD3GgE2IsARdmkSPWUJfPvo1ifdjYHTJuTufI/lPSRL0Y08uDCfs6N
         phFimrv5nSpfYdOyxY2Z+capVO+xG2f282wgqHloOkKjwgD6zi07OC4b/zeoGK1KnQUX
         rnb8ud8xrzoethH9N9WG3u+0nI+HecUyGQyJf5l71JSHTmYI+2myTQ4yiJ8BdlTk7Anx
         0MSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tlOex+gWQYpxiWEeGdiftgedeC2MlUqgIjmdPHTDpf0=;
        b=WHFpNwIevI+qXRsRJm0A9BY2CPP6uadVpCTtObq4sbbESGiryfjc3FndqmRysU0l3h
         dXVxv9f6ctDtNm39wGbLEl/ifQR/NBVeH1UT3IUGLR9DPn1gR2DF0wP9nmqBzIqx5Q13
         zoHPZuuNDYQhz7CxKoPjQ4QSCrAT7kDB/EGBuQIaDjgVCpKZui2HwrefgmF+AtF5SeCh
         KQ+0FEoH96DecFWXTQrHha91W6inwvPEVaN+6ipD8oAmlLFYPTEt7LZFI2AMGk3BGljn
         XlQHLrHic13m8cmd2BLTiHQOI/dOOA8ZTZDM5kOntTyHcGtGIPX468/o8AtLIxwpTLT6
         tNnw==
X-Gm-Message-State: APjAAAUvibtSShrG7b5+skiPezh3hO0l+GU/8IM8suEOlreHQ398KKJE
        PiQeawbMDULGfFM9hfnOglv8S1D9CQ8WoQ==
X-Google-Smtp-Source: APXvYqzEKeOkFh9vf47GMd6yj2FMPFw2hdlQUS3eu6OZlU4mrLvUX9yNWOgohfsiTZaIAhCT4qa2ew==
X-Received: by 2002:a17:90a:6583:: with SMTP id k3mr3471330pjj.50.1572924816378;
        Mon, 04 Nov 2019 19:33:36 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id q26sm15266257pgk.60.2019.11.04.19.33.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 19:33:35 -0800 (PST)
Subject: Re: [PATCH V4] block: optimize for small block size IO
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
References: <20191104181403.GA8984@kmo-pixel>
 <20191104181541.GA21116@infradead.org> <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
 <20191104184217.GD8984@kmo-pixel> <20191105011135.GD11436@ming.t460p>
 <20191105021130.GB18564@moria.home.lan> <20191105022046.GF11436@ming.t460p>
 <20191105023002.GC18564@moria.home.lan>
 <c41fd177-21e7-7e36-960f-fb1f7808f3e2@kernel.dk>
 <20191105031417.GA5872@moria.home.lan>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e0d76d36-157a-138e-12c1-a3f1e318f71c@kernel.dk>
Date:   Mon, 4 Nov 2019 20:33:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105031417.GA5872@moria.home.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/4/19 8:14 PM, Kent Overstreet wrote:
> On Mon, Nov 04, 2019 at 07:38:42PM -0700, Jens Axboe wrote:
>> This is where my knee jerk at the initial "partial completions" and
>> "should be trivial" start to kick in. I don't think they are
>> necessarily hard, but they aren't free either. And you'd need to be
>> paying that atomic_dec cost for every IO.
> 
> No need - you added the code to avoid that atomic dec for bi_remaining
> in the common case, the same approach will work here.

I guess that would work for the common case of not splitting. If we split,
then it's OK to pay a higher cost. We would have anyway, with the
existing code.

>> currently have to do, maybe not... If it's a clear win, then it'd be
>> an interesting path to pursue. But we probably won't have that answer
>> until at least a hacky version is done as proof of concept.
>>
>> On the upside, it'd simplify things to just have the mapping in one
>> place, when the request is setup. Though until all drivers do that
>> (which I worry will be never), then we'd be stuck with both. Maybe
>> that's a bit to pessimistic, should be easier now since we just have
>> blk-mq.
> 
> blk_rq_map_sg isn't called from _that_ many places, I suspect once
> it's figured out for one driver the rest won't be that bad.

It's definitely easier than it would have been, most things are pretty
streamlined now with the blk-mq conversion. And the ones that don't call
blk_rq_map_sg() usually don't do DMA on the requests. Sizes tend to be
more arbitrary there, and not hard boundaries.

> And even if some drivers remain unconverted, I personally _much_
> prefer this approach to more special case fast paths, and I bet this
> approach will be faster anyways.
> 
> Also - regarding driver allocating of the sglists, I think most high
> performance drivers preallocate a pool of sglists that are all sized
> to what the device is capable of.

They do, but most of them probably also assume on sg list per request.
We'd have one request now instead of multiple, so either serializing it
(which would definitely suck for some common cases), or doing something
very funky with mapping to multiple requests at the same time.

But I don't think we should argue this much more. If someone wants to do
the work to make this work, even a prototype, it's much better to argue
over actual code then potential issues and wins now.

-- 
Jens Axboe

