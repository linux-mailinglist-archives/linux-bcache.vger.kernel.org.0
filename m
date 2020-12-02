Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E6F2CC9BE
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Dec 2020 23:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgLBWkm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 17:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgLBWkm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 17:40:42 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27530C061A04;
        Wed,  2 Dec 2020 14:40:02 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id y18so345036qki.11;
        Wed, 02 Dec 2020 14:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lcXYuHAwEN3bFhp+hU4mksRhemmvNH25lzSQUI1hows=;
        b=vZmGZVPgXuJbZvST76J3BO6XbX+Tve4svP6SCrMkq4MsSL57hAOzC2GfFbKmYq80X3
         A/ZejAYJW4vLui7jj9tuqACY3sfUrHF8tBFt/l20GoPKoDv3hFfJbAmC/c+RKZSstyBA
         5gantAs/mFLW+Fbz4XV/GDFSBODWPBc0cZ23QtxaKIgHZNAD56lJNiBZMnvqFbN90SBX
         7GvsFTI+VgHLZ/sesPkP706bos+5nB0WaSnxUdUD2eDqFst6SmcubE2DV4aanqzmFXea
         n9OFtnt28NxagQVyBGv0fHyA06JKzJhp1e8EH9t3pDYFhTeXgnJoOGOHFS3QAYH8PnOX
         zBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lcXYuHAwEN3bFhp+hU4mksRhemmvNH25lzSQUI1hows=;
        b=EpOluf2IXOjouei+F7fqabfBPhhhgPNH7sI1i0ejOJ7pxaEEjUR6dSouV0+ut13TDV
         wbX7a5qCTytUsT75FcfE4TEjjm3o6RsvGIub771uiatqme883k71p1vBdxtwpVgtTpMO
         Y/8AJXDnM7uW0WcQrXrq8ezCiu3ji74glpKCyX6kti7XmlVmHSmSsIGmGkHIJLAyvysv
         hOrdrLDkuqcdXp2MuQ4O/DdqTOE0qjcr7IjxqMIp9K+R1Y7mHaFT2b8aXZ/8+bWSYY63
         Ru30S1UWxcRpehUTF0q3NeW7FYKjPGWxshuzm3qN48XvQ74bv+Xa0Lia2cv0Sv6r942n
         aL+A==
X-Gm-Message-State: AOAM53361WulKc+R5KmfLQnv251VS6rpi3Gka+dML+edlXH90XK70sqX
        cOhQKkzFMdunk6lDZox07Qc=
X-Google-Smtp-Source: ABdhPJzlGJwRriEEpzrUJVGgCffXwM6L1NA2hwaKhO2rHq7h+FQnF+3tfM3qdL7QbQn44WCGvJfk/g==
X-Received: by 2002:a37:4854:: with SMTP id v81mr42262qka.20.1606948801332;
        Wed, 02 Dec 2020 14:40:01 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id y192sm67899qkb.12.2020.12.02.14.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:40:00 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 17:39:32 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 1/9] brd: remove the end of device check in brd_do_bvec
Message-ID: <X8gXpGs34mQTeSJ6@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:16PM +0100, Christoph Hellwig wrote:
> The block layer already checks for this conditions in bio_check_eod
> before calling the driver.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
