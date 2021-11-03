Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4F74440F7
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Nov 2021 13:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhKCMDK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Nov 2021 08:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhKCMDK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Nov 2021 08:03:10 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4664C061714
        for <linux-bcache@vger.kernel.org>; Wed,  3 Nov 2021 05:00:33 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id r3so910066iod.6
        for <linux-bcache@vger.kernel.org>; Wed, 03 Nov 2021 05:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=cDei1keWsvl4PYK3ISz0TTskfmJQPyTanC8QtP8c2IM=;
        b=we1aIeYSg+m4v2LTpkEaLME2qgBx8Itr2kFLT04/aFMaj3H+yN4jGnKM54ZxZmoPyN
         MK4D2V3Jmn5r0BaGcHaUgO4+85f6UBYB+TAipO29YJq386QPvr0j11FMSccvn9vr3dY9
         moB/4ZBhQe70hlnJOCR6FS2M/lenAn7vAidXDmmEIlGW34OgvLFr+tvAf+ibt6MWYISi
         nSchkdZQctFQNtoTrTORICb7SMzAxK4sg1gquesdS0wgMjDsuRuXBQ9DHzXQPwPCNnr2
         0XaE4H8+x9o/tiKNFPaa9hrsHGTaNa6s5XxK38wcraTTzdR+exknT//QVJz9IGU/yiJ1
         OxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=cDei1keWsvl4PYK3ISz0TTskfmJQPyTanC8QtP8c2IM=;
        b=jWD6yOoqoca+r1dyClt6jghLcwxAjKgwOqvh68Fws5RqrecbRwTAOylHk/CYF75rJN
         ZXDT8ECgudF76mTkLWSLKf5eF3AfVV59yraWnr7+APEOoDd5/Bs3F9Jw+I3lAFlchxDn
         +LvT2ZkwCfEfGTf73hKkB67mGEPsf1iPj3V1JA0yynOxn+Bsdxjl3DZeCoaKtyvku4Gz
         Cgr7OvAB86rlnPoGobjk1Isx7xo5rz0+2fmSSHDwlO+coU9TRmzVlmVl6MiLQcyMWQO1
         nb0ZXr6021xerS9AP0Th6KfOIUNPjKvaQ1Z8HRLdwewwd5+tiOgtFobpkibK7eNncnIc
         VhDA==
X-Gm-Message-State: AOAM533mMjxBqT4gIOFyUmSZkB4gllaeI5MmCfHNcex3N6JOxomSvjpS
        cZ7HtRe6sWoIGaVN5YJY+5Ngaw==
X-Google-Smtp-Source: ABdhPJy+u/6YTvU0aq4oLcJFO/i8gutUloaF0ii+Z5JVatTb1s+jELaU9oDz9FbgYRj/b9L6xTMzFw==
X-Received: by 2002:a05:6602:14c9:: with SMTP id b9mr249851iow.196.1635940833141;
        Wed, 03 Nov 2021 05:00:33 -0700 (PDT)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id l9sm1174074ilh.21.2021.11.03.05.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 05:00:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-block@vger.kernel.org
In-Reply-To: <20211103064917.67383-1-colyli@suse.de>
References: <20211103064917.67383-1-colyli@suse.de>
Subject: Re: [PATCH] bcache: fix use-after-free problem in bcache_device_free()
Message-Id: <163594083246.585712.11771708105907257182.b4-ty@kernel.dk>
Date:   Wed, 03 Nov 2021 06:00:32 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 3 Nov 2021 14:49:17 +0800, Coly Li wrote:
> In bcache_device_free(), pointer disk is referenced still in
> ida_simple_remove() after blk_cleanup_disk() gets called on this
> pointer. This may cause a potential panic by use-after-free on the
> disk pointer.
> 
> This patch fixes the problem by calling blk_cleanup_disk() after
> ida_simple_remove().
> 
> [...]

Applied, thanks!

[1/1] bcache: fix use-after-free problem in bcache_device_free()
      commit: 8468f45091d2866affed6f6a7aecc20779139173

Best regards,
-- 
Jens Axboe


