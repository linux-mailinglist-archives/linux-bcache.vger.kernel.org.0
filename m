Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91173EF3D8
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 04:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387439AbfKEDOW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 22:14:22 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40510 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbfKEDOV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 22:14:21 -0500
Received: by mail-qk1-f193.google.com with SMTP id a18so2220135qkk.7;
        Mon, 04 Nov 2019 19:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pgfGmkFIweedbyHt5v4lKizRPqq/wqU9L9J1WIBR5W8=;
        b=bN2pynleNMfgcb9JsWq/qzJqU9KVFSg11FMWOm6EwVg3kzzR5sNmSKx9uKePQwDryr
         e0UES0IgfgE04hjSRDhGZ9t/iVl51SMgzyNVAuzw01hAXy2ijbCNT6omKwQ5qcaV5iLL
         nO/tXTEQzWE4oV20v+HpDxyS+/PeTrOxz55LxoR2X/s47FacxDh9MCIzoculxBv55izV
         lCoqho63Z1+j7QBvnkrRn5a/WNxg42ptQzW6525/mGQe6QHgkUomBfz1PSeueRqy1soA
         Ns0en9PV01SWzI+hbRElpOLH9ueKXL9yxxChA68PNnuGB35kaX8r+9Rqrskd3qZjlnaP
         VLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pgfGmkFIweedbyHt5v4lKizRPqq/wqU9L9J1WIBR5W8=;
        b=nODEiDk2FR4sPfjNUSATTGW87OB5vtloWq/pQ1HA7Nmq8rqeVlk7GynWyY1/KiSmoy
         xy25AqRIm2+TGXffLD+xg2hxRGhOeuex89eSR5FeSFac9QdltS57amMwtBj+7yuJmXSj
         uzBtX4POT2HiK8gXpIOVstbS211xuS3APg5lxgXr0QYOnz6uXYNl9OYFmRwrj9QwDvV3
         ciA5eceuj6+ECY+yopntmY+CwzcKRqQyyEmK3598WnMT6mSR6vbMDNZexhtXsv4pPm6V
         HaDCqglljnTNv2Y4a52JmItQCiH418kq5+ZA31gpUoeSeDVlLDY3xulTJXm6IkPZe0X8
         9nxA==
X-Gm-Message-State: APjAAAVf6MwL89fgTN3zfEWzs2e5Yh90Zi/qAd5quIZ4UB588YDfu40R
        VI2CSeNclLBFsUSQ4eVJ7bHH7S0gJw==
X-Google-Smtp-Source: APXvYqz2cJ2KlnY5ngk9PlILvEun3tUdzEcjHoydnhabyUHHItxmJVjAqD1DHR26yah7fe7aKpLXfg==
X-Received: by 2002:a37:684b:: with SMTP id d72mr10846753qkc.314.1572923660511;
        Mon, 04 Nov 2019 19:14:20 -0800 (PST)
Received: from moria.home.lan ([2601:19b:c500:a1:7285:c2ff:fed5:c918])
        by smtp.gmail.com with ESMTPSA id h20sm2253328qtr.59.2019.11.04.19.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 19:14:19 -0800 (PST)
Date:   Mon, 4 Nov 2019 22:14:17 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191105031417.GA5872@moria.home.lan>
References: <20191104181403.GA8984@kmo-pixel>
 <20191104181541.GA21116@infradead.org>
 <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
 <20191104184217.GD8984@kmo-pixel>
 <20191105011135.GD11436@ming.t460p>
 <20191105021130.GB18564@moria.home.lan>
 <20191105022046.GF11436@ming.t460p>
 <20191105023002.GC18564@moria.home.lan>
 <c41fd177-21e7-7e36-960f-fb1f7808f3e2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c41fd177-21e7-7e36-960f-fb1f7808f3e2@kernel.dk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 04, 2019 at 07:38:42PM -0700, Jens Axboe wrote:
> This is where my knee jerk at the initial "partial completions" and
> "should be trivial" start to kick in. I don't think they are necessarily
> hard, but they aren't free either. And you'd need to be paying that
> atomic_dec cost for every IO.

No need - you added the code to avoid that atomic dec for bi_remaining in the
common case, the same approach will work here.

> currently have to do, maybe not... If it's a clear win, then it'd be an
> interesting path to pursue. But we probably won't have that answer until
> at least a hacky version is done as proof of concept.
> 
> On the upside, it'd simplify things to just have the mapping in one
> place, when the request is setup. Though until all drivers do that
> (which I worry will be never), then we'd be stuck with both. Maybe
> that's a bit to pessimistic, should be easier now since we just have
> blk-mq.

blk_rq_map_sg isn't called from _that_ many places, I suspect once it's figured
out for one driver the rest won't be that bad.

And even if some drivers remain unconverted, I personally _much_ prefer this
approach to more special case fast paths, and I bet this approach will be faster
anyways.

Also - regarding driver allocating of the sglists, I think most high performance
drivers preallocate a pool of sglists that are all sized to what the device is
capable of.
