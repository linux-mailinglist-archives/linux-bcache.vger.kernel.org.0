Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2662A11B58D
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Dec 2019 16:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbfLKPR6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Dec 2019 10:17:58 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36455 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731235AbfLKPR5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:57 -0500
Received: by mail-qt1-f194.google.com with SMTP id k11so6567389qtm.3;
        Wed, 11 Dec 2019 07:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSyEpbaPokG867/3ubUmUtm6jKXW5rzJQg/EbiPjhi4=;
        b=mqEB68h5cwRkQneshEFqEuVp6ajAXX07NsifjCFCUzb4sLj/5Josuh8ybzdPJQYNPq
         nJrFY1B/qwecZNYWW4pA6FNGTgKVMMXfFGkws1RNT9cE32gFgvWXyJ94Yp/UbnS6T825
         TbET/4uUgPaFyw3/E6OFEfKVAnCbl/eTDaF7ZEz72WvawC39UlhTayQ8qNMNJwVm9S5Z
         AxiY0HzJ2ZVnD5QMVBP4Opix6asbBS1MRUIxOzS857zNVNIVuctLlkGPT0DEyDcnyx87
         wjemeZOUJsYxtI6+MPXtSExkuDQnb2EeaI5J4Ue4OKYYCiU6uP9NriiSLbF5tP94po0v
         HbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSyEpbaPokG867/3ubUmUtm6jKXW5rzJQg/EbiPjhi4=;
        b=MryyKFBq9GnG91K5GiuU2IwSuOlgLFFR5/3Dqg1RJZGLfOMMnShOEKrsYHZZ9ZZ+NI
         /dWVY8+eZNA2Mj+QFzdiZWkDfAJhkQ3b4KwNZMMpZEe1IaimjlsU5Xhl2vzAinDXSlIP
         hf1jrTa5kCI9IdWmwQB7oO0zubmmL11ADhM4MyY11ZYEGg7v5u772RPwDReISX17sngT
         61tG4RdBkspqahJwys+sNEcca+PgETjguDqrHtfNI1D6Yx8vNWAXIKYcKOIX3GQpiSd1
         4ADcRgBSDo3rczbccUDhfPEA2/ZEvG3VykuiZB9Akc5zs/u9kLPRvnel926OjGOaRnPb
         8mZw==
X-Gm-Message-State: APjAAAXUDY/XbB2SRMWhjY6tKZt4hidIKTwlgXHJcOyUvMYLYkoiR58V
        hqTH5Z+3jQIhmtJ6Wz1JEZtz22FOG58Jv1T81tU=
X-Google-Smtp-Source: APXvYqxRSL9c0VQzF96BLc43OPSIAk830pM0oJYwLpIpze59iYWOUCDFgCatZK0JG1QynUUg3uymVmyS9L/M36mUCI4=
X-Received: by 2002:ac8:2898:: with SMTP id i24mr3197998qti.259.1576077476110;
 Wed, 11 Dec 2019 07:17:56 -0800 (PST)
MIME-Version: 1.0
References: <20191209093829.19703-1-hch@lst.de> <b19f677f-d8e5-44af-0575-d1fb74835c65@suse.de>
In-Reply-To: <b19f677f-d8e5-44af-0575-d1fb74835c65@suse.de>
From:   Liang C <liangchen.linux@gmail.com>
Date:   Wed, 11 Dec 2019 23:17:44 +0800
Message-ID: <CAKhg4tJGWwm5cTkctuch-ACrDOLfLKK8HCCTcJZPF2iURc9rUg@mail.gmail.com>
Subject: Re: bcache kbuild cleanups
To:     Christoph Hellwig <hch@lst.de>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

 > Hi Coly and Liang,
 >
 > can you review this series to sort out the bcache superblock reading for
 > larger page sizes?  I don't have bcache test setup so this is compile
 > tested only.
 >
Hi Christoph,

Thanks for making the patches. I looked through them, but didn't see
where cache and cached_dev have their sb_disk assigned.
That would be an issue when __write_super tries to add the
corresponding page to the bio. Not sure if there is there anything I
missed.

Liang
